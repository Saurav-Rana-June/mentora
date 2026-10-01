'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "64ce950a416e8e734d2f1506c17fa7b7",
"assets/AssetManifest.bin.json": "ec59c4afac085bf61dbbab0800c60013",
"assets/AssetManifest.json": "668989fab93229005a144ceddfbe8e7e",
"assets/assets/fonts/fa-brands-400.ttf": "e9a507bae9d52442aa73f9072bf318dc",
"assets/assets/fonts/fa-light-300.ttf": "13cb2d219ef25b15d50aadecbe9c86cb",
"assets/assets/fonts/fa-regular-400.ttf": "1e6d83dbc4dcc0fc65b746f6db19e4f6",
"assets/assets/fonts/fa-solid-900.ttf": "5803286fc41b825ba38a7a850ff2cae5",
"assets/assets/fonts/Satoshi-Bold.otf": "4a6fdcfc68ad464e8a9811e4edcacf00",
"assets/assets/fonts/Satoshi-Medium.otf": "378def5c1f4df7eb6554a88608893391",
"assets/assets/fonts/Satoshi-Regular.otf": "177a4dda04b52dedbd966942e932c5dc",
"assets/assets/gifs/brain_med.gif": "bcbce84ea9880688e4e587a1975aef87",
"assets/assets/images/banner.png": "021ca1f9875a62c2cd513b50421f5b65",
"assets/assets/images/light_mode_ss/ssd_1.png": "c9f6699f6d114d6acc81b5f26d091151",
"assets/assets/images/light_mode_ss/ssd_2.png": "a78eb3366d8491da6ad8632a406f5d3d",
"assets/assets/images/light_mode_ss/ssd_3.png": "51627152f78b8635eaac73e6ae7a0138",
"assets/assets/images/light_mode_ss/ssd_4.png": "778f849ff9ffcc7d4859e19ccc758a9c",
"assets/assets/images/light_mode_ss/ssd_5.png": "45b329048c21d3967a57048892a0bf9f",
"assets/assets/images/light_mode_ss/ssd_6.png": "152a992253587cc1bcda5edb070e15a5",
"assets/assets/images/light_mode_ss/ssd_7.png": "9043d2a627b0e11c45fc06bac9a3aa9f",
"assets/assets/images/light_mode_ss/ssd_8.png": "e8eb7094a682c50ab0df76d62501819a",
"assets/assets/logos/apple.png": "7192d29ea32e99e4f2acb6a717cc3939",
"assets/assets/logos/facebook.png": "51232b07c865f295c25f5afb9ec4ed61",
"assets/assets/logos/google.png": "bdd69bf4a9f8192f4a78708637995447",
"assets/assets/logos/logo.png": "27f2f0c1b96df7d9abadec823331ea3c",
"assets/assets/logos/x.png": "c019bd434e5489eb40e386b60cf045c9",
"assets/assets/moods/Angry%2520Face.svg": "6c339465a837d72858ebe503f9fce06d",
"assets/assets/moods/Happy%2520Face.svg": "d573e2ff7f5b9821590ee2e1cac1a7d9",
"assets/assets/moods/Normal%2520Face.svg": "4abd1ee4680d6d1f84e6f27782001127",
"assets/assets/moods/Not%2520Good%2520Face.svg": "4ace32144bce24ae3e3f0721dc8a751a",
"assets/assets/moods/Very%2520Happy%2520Face.svg": "c4c274ab82b9cc2c1a5c47c85794a7ad",
"assets/FontManifest.json": "a189ece85536892ba7bcf7a03e85730b",
"assets/fonts/MaterialIcons-Regular.otf": "2928eeb629e3df1f9be4ab8e59675b75",
"assets/NOTICES": "9cc5b1bc4c090a80851f292feed91d74",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "2e774071ca021afff01423eb692b2842",
"assets/packages/my_icons/assets/fonts/fa-brands-400.ttf": "e9a507bae9d52442aa73f9072bf318dc",
"assets/packages/my_icons/assets/fonts/fa-light-300.ttf": "13cb2d219ef25b15d50aadecbe9c86cb",
"assets/packages/my_icons/assets/fonts/fa-regular-400.ttf": "1e6d83dbc4dcc0fc65b746f6db19e4f6",
"assets/packages/my_icons/assets/fonts/fa-solid-900.ttf": "5803286fc41b825ba38a7a850ff2cae5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "c7da560c6bb575836b7a995f835bd74a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "6defe6982254156c28b994e0826c6a9e",
"/": "6defe6982254156c28b994e0826c6a9e",
"main.dart.js": "6c786f909d2f6003602adc2d5b2474ee",
"manifest.json": "385a67a5a097cfa5f1993efda9c670a0",
"version.json": "f167c0801f01be0b7218f633f5982ae4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
