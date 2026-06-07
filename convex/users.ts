import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const createUser = mutation({
  args: { name: v.string(), email: v.string(), password: v.string() },
  handler: async (ctx, args) => {
    // Check if user already exists
    const existingUser = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    if (existingUser) {
      return existingUser._id;
    }

    // Create new user
    const newUserId = await ctx.db.insert("users", {
      name: args.name,
      email: args.email,
      password: args.password,
    });
    
    // Create default wallets for new user
    await ctx.db.insert("wallets", { userId: newUserId, name: "Cash", type: "cash", balance: 0 });
    await ctx.db.insert("wallets", { userId: newUserId, name: "GCash", type: "ewallet", balance: 0 });

    return newUserId;
  },
});

export const loginUser = query({
  args: { email: v.string(), password: v.string() },
  handler: async (ctx, args) => {
    const user = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();
    
    if (user && user.password === args.password) {
      return user._id;
    }
    throw new Error("Invalid credentials");
  },
});
