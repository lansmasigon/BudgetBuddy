import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";
import { api } from "./_generated/api";

const http = httpRouter();

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

http.route({
  path: "/api/createUser",
  method: "OPTIONS",
  handler: httpAction(async (_, request) => {
    return new Response(null, {
      status: 204,
      headers: corsHeaders,
    });
  }),
});

http.route({
  path: "/api/createUser",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    try {
      const { name, email, password } = await request.json();
      const userId = await ctx.runMutation(api.users.createUser, { name, email, password });
      return new Response(JSON.stringify({ userId }), {
        headers: { 
          "Content-Type": "application/json",
          ...corsHeaders
        },
      });
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), {
        status: 500,
        headers: { 
          "Content-Type": "application/json",
          ...corsHeaders
        },
      });
    }
  }),
});

http.route({
  path: "/api/loginUser",
  method: "OPTIONS",
  handler: httpAction(async (_, request) => {
    return new Response(null, {
      status: 204,
      headers: corsHeaders,
    });
  }),
});

http.route({
  path: "/api/loginUser",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    try {
      const { email, password } = await request.json();
      const userId = await ctx.runQuery(api.users.loginUser, { email, password });
      return new Response(JSON.stringify({ userId }), {
        headers: { 
          "Content-Type": "application/json",
          ...corsHeaders
        },
      });
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), {
        status: 401,
        headers: { 
          "Content-Type": "application/json",
          ...corsHeaders
        },
      });
    }
  }),
});

http.route({
  path: "/api/getDashboard",
  method: "OPTIONS",
  handler: httpAction(async (_, request) => {
    return new Response(null, { status: 204, headers: corsHeaders });
  }),
});

http.route({
  path: "/api/getDashboard",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    try {
      const { userId } = await request.json();
      const data = await ctx.runQuery(api.dashboard.getDashboardData, { userId: userId as any });
      return new Response(JSON.stringify(data), {
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), {
        status: 500,
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    }
  }),
});

http.route({
  path: "/api/addTransaction",
  method: "OPTIONS",
  handler: httpAction(async (_, request) => {
    return new Response(null, { status: 204, headers: corsHeaders });
  }),
});

http.route({
  path: "/api/addTransaction",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    try {
      const args = await request.json();
      const txId = await ctx.runMutation(api.transactions.addTransaction, args);
      return new Response(JSON.stringify({ txId }), {
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), {
        status: 500,
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    }
  }),
});

http.route({
  path: "/api/addGoal",
  method: "OPTIONS",
  handler: httpAction(async (_, request) => {
    return new Response(null, { status: 204, headers: corsHeaders });
  }),
});

http.route({
  path: "/api/addGoal",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    try {
      const args = await request.json();
      const goalId = await ctx.runMutation(api.goals.addGoal, args);
      return new Response(JSON.stringify({ goalId }), {
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), {
        status: 500,
        headers: { "Content-Type": "application/json", ...corsHeaders },
      });
    }
  }),
});

export default http;
