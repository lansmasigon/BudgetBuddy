import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    name: v.string(),
    email: v.string(),
    password: v.string(),
    budgetingStyle: v.optional(v.string()), // e.g. "Zero-Based Budgeting"
  }).index("by_email", ["email"]),

  wallets: defineTable({
    userId: v.id("users"),
    name: v.string(), // e.g. "Cash", "GCash"
    type: v.string(), // "cash", "bank", "ewallet"
    balance: v.number(),
  }).index("by_user", ["userId"]),

  transactions: defineTable({
    userId: v.id("users"),
    walletId: v.id("wallets"),
    type: v.string(), // "income", "expense", "transfer"
    amount: v.number(),
    category: v.string(), // e.g. "Food", "Transport"
    description: v.optional(v.string()),
    date: v.string(), // ISO string
  }).index("by_user", ["userId"]).index("by_wallet", ["walletId"]),

  goals: defineTable({
    userId: v.id("users"),
    name: v.string(), // e.g. "Emergency Fund"
    targetAmount: v.number(),
    currentAmount: v.number(),
    linkedWalletId: v.optional(v.id("wallets")),
    targetDate: v.optional(v.string()),
  }).index("by_user", ["userId"]),

  budgets: defineTable({
    userId: v.id("users"),
    category: v.string(),
    limit: v.number(),
    monthYear: v.string(), // e.g. "2025-06"
  }).index("by_user", ["userId"]),
});
