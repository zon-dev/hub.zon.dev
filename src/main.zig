const std = @import("std");
const zinc = @import("zinc");

pub fn main() !void {
    const engine = try zinc.Engine.default();
    std.debug.print("Listening on: 127.0.0.1:{any}\n", .{ engine.get_port() });

    // const ctx = try zinc.Context();

    var router = engine.router();
    router.get("/hello", hello);

    _ = try engine.run();
}



fn hello(ctx: zinc.Context, req: zinc.Request, resp: zinc.Response) void {
    _ = ctx;
    _ = req;
    try resp.set_body("Hello, World!");
}