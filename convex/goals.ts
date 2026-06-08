import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const getGoals = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("goals")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();
  },
});

export const addGoal = mutation({
  args: {
    userId: v.id("users"),
    name: v.string(),
    targetAmount: v.number(),
    targetDate: v.string(),
    linkedWallet: v.optional(v.string()), // wallet name
  },
  handler: async (ctx, args) => {
    let linkedWalletId = undefined;
    if (args.linkedWallet) {
      const wallet = await ctx.db
        .query("wallets")
        .withIndex("by_user", (q) => q.eq("userId", args.userId))
        .filter((q) => q.eq(q.field("name"), args.linkedWallet))
        .first();
      if (wallet) {
        linkedWalletId = wallet._id;
      }
    }

    const goalId = await ctx.db.insert("goals", {
      userId: args.userId,
      name: args.name,
      targetAmount: args.targetAmount,
      currentAmount: 0,
      targetDate: args.targetDate,
      linkedWalletId: linkedWalletId,
    });
    return goalId;
  },
});
