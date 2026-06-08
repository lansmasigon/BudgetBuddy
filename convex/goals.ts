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
  },
  handler: async (ctx, args) => {
    const goalId = await ctx.db.insert("goals", {
      userId: args.userId,
      name: args.name,
      targetAmount: args.targetAmount,
      currentAmount: 0,
      targetDate: args.targetDate,
    });
    return goalId;
  },
});
