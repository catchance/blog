var cacheName = "josephearl.co.uk::v1::static";
self.addEventListener("install", function (a) {
    a.waitUntil(caches.open(cacheName).then(function (a) {
        return a.addAll(["/", "/index.json", "/css/style.css", "/fonts/icons.woff", "/js/lunr.js", "/js/main.js", "/js/search.js", "/js/highlight.js"]).then(function () {
            self.skipWaiting()
        })
    }))
}), self.addEventListener("fetch", function (a) {
    var b = a.request;
    if ("GET" !== b.method) return void a.respondWith(fetch(b));
    a.respondWith(caches.open(cacheName).then(function (c) {
        return c.match(a.request).then(function (d) {
            return d || fetch(a.request).then(function (a) {
                return a.url.match(/\/post\//) && c.put(b, a), a
            })
        })
    }))
});
