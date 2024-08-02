const std = @import("std");
const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{
        .port = 8081,
        .addr = "0.0.0.0",
    });

    std.debug.print("Listening on: {any}\n", .{zinc.getAddress()});

    try zinc.use(.{
        .prefix = "/",
        // .handler_fn = cors,
        .handler_fn = unauthorized,
        
    });

    // engine.use(.{
    //     .handler = fn(ctx: *z.Context, req: *z.Request, res: *z.Response) anyerror!void {
    //         try ctx.next(req, res),
    //     },
    // });

    var router = zinc.getRouter();
    try router.get("/", hello);
    try router.post("/hi", hi);
    try router.add(std.http.Method.GET, "/ping", ping);

    // for (router.getRoutes().items) |r| {
    //     std.debug.print("{s} | {s}\n", .{ @tagName(r.http_method), r.path });
    // }

    var catchers = zinc.getCatchers();
    try catchers.put(.not_found, notFound);
    // try catchers.put(.forbidden, forbidden);
    // try catchers.put(.unauthorized, unauthorized);

   try zinc.run();
}

fn cors(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    _ = ctx;
}

fn unauthorized(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.HTML(.{
        .status = .unauthorized,
    },"<h1>401 Unauthorized</h1>" );
}

fn forbidden(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.HTML(.{
        .status = .forbidden,
    },"<h1>403 Forbidden</h1>" );
}

fn notFound(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.HTML(.{
        .status = .not_found,
    },"<h1>404 Not Found</h1>" );
}

fn hello(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.HTML(.{},"<h1>Hello World!</h1>" );
}

fn hi(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.JSON(.{},.{
        .message ="hi!",
    });
}

fn ping(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.Text(.{},"pong!" );
}
