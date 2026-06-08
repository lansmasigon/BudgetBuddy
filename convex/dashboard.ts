import { query } from "./_generated/server";
import { v } from "convex/values";

export const getDashboardData = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    // Fetch User
    const user = await ctx.db.get(args.userId);
    if (!user) throw new Error("User not found");

    // Fetch Wallets
    const wallets = await ctx.db
      .query("wallets")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    // Fetch Transactions (limit to latest 10 for dashboard)
    const transactions = await ctx.db
      .query("transactions")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .take(10);

    // Fetch Goals and attach current wallet balance
    const rawGoals = await ctx.db
      .query("goals")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const goals = rawGoals.map((g) => {
      let currentAmount = g.currentAmount;
      if (g.linkedWalletId) {
        const linkedWallet = wallets.find((w) => w._id === g.linkedWalletId);
        if (linkedWallet) {
          currentAmount = linkedWallet.balance;
        }
      }
      return { ...g, currentAmount };
    });

    return {
      user: { name: user.name, email: user.email },
      wallets: wallets,
      transactions: transactions,
      goals: goals,
    };
  },
});
