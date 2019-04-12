function isRetina() {
    var i = "(-webkit-min-device-pixel-ratio: 1.5),(min--moz-device-pixel-ratio: 1.5),(-o-min-device-pixel-ratio: 3/2),(min-resolution: 1.5dppx)";
    return window.devicePixelRatio > 1 ? !0 : window.matchMedia && window.matchMedia(i).matches ? !0 : !1
}

function retina() {
    isRetina() && Array.prototype.slice.call(document.querySelectorAll("img.x2")).map(function (e) {
        var n = e.src;
        n = n.replace(".png", "@2x.png"), n = n.replace(".jpg", "@2x.jpg"), e.src = n
    })
};

function documentReady(a, b, c) {
    b = document, c = 'addEventListener';
    b[c] ? b[c]('DOMContentLoaded', a) : window.attachEvent('onload', a)
};documentReady(retina);
hljs.initHighlightingOnLoad();
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/js/service-worker.js', {scope: '/'})
}