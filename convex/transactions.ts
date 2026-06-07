import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const getTransactions = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("transactions")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();
  },
});

export const addTransaction = mutation({
  args: {
    userId: v.id("users"),
    walletName: v.string(),
    type: v.string(),
    amount: v.number(),
    category: v.string(),
    description: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    // Look up wallet ID by name and user
    const wallet = await ctx.db
      .query("wallets")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .filter((q) => q.eq(q.field("name"), args.walletName))
      .first();

    if (!wallet) throw new Error("Wallet not found");

    // 1. Insert transaction
    const transactionId = await ctx.db.insert("transactions", {
      userId: args.userId,
      walletId: wallet._id,
      type: args.type,
      amount: args.amount,
      category: args.category,
      description: args.description,
      date: new Date().toISOString(),
    });

    // 2. Update wallet balance
    const balanceChange = args.type === "income" ? args.amount : -args.amount;
    await ctx.db.patch(wallet._id, {
      balance: wallet.balance + balanceChange,
    });

    return transactionId;
  },
});
