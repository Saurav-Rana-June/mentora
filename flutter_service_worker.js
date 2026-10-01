'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "e2bae1895e2736efe269852c8959cc0e",
".git/config": "d388655ffc5a090c9eeb29dd3335851f",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "b2d0d8a38ecc867182c7b13a232e6cc3",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "735359a1190401fb425217be5194c43c",
".git/logs/refs/heads/gh-pages": "735359a1190401fb425217be5194c43c",
".git/logs/refs/remotes/origin/gh-pages": "142ff8291e0fadb576028546bb9cca80",
".git/objects/02/1d4f3579879a4ac147edbbd8ac2d91e2bc7323": "9e9721befbee4797263ad5370cd904ff",
".git/objects/09/46d9776e9896129aab7e11ce221574d5bd4f15": "080565c587a915227ee6ad9a4f76dccd",
".git/objects/0c/55dd7a66ecd640f347c249d5670d001fb37b90": "8dbbb7d7fb5e504aa3a31d512ebf0d75",
".git/objects/0f/aa93990903969fa273556b9a7dfb842f9bde8a": "8e6c4942a99b87f8d05ad870c0d9b9c4",
".git/objects/18/aabcfd364c24ab2c4ef8adfc3e1e8a040b5219": "6d3dbf442206776970b4ff1da66aab7b",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/21/f6c3a1eee46f1cf34952cc30aa03ebf62446f8": "552996b0119c163ad39813ed9a248b25",
".git/objects/28/d63ddbeb6b53281f6b0cb8ffc3104c981bb993": "3c5ef4807782428223e9df2f221cf788",
".git/objects/29/9e5ab9b613a7e028c89c2cb7e9f13d6b5dd79c": "5c86b4295155b6f80098ab153024556c",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/2c/2d7e863f1025b7f93b9ce481d6ecf3614290d8": "121d4ead1e1c346a4449b6f205d87bc0",
".git/objects/2d/30dd5352f03098e202717c6a6577dffc4767db": "7002f11bb12b11bd407c1bc025f92dcb",
".git/objects/30/96302522b7f7bd90e71a7bf20f0547aefd8d2e": "3ea490412cc88a68fac9b9c1ba5c5dd1",
".git/objects/33/3f1f38e6b3bc11b4d6c19c94c9d7e97c2dc3e5": "25947955528efbbdb31e541d456df25b",
".git/objects/35/13a83bb9bab6462ca8309e4b1d447ebba9cedd": "c526d444bf3ee0543b99436cafbaf8e4",
".git/objects/3a/2e0c537b0172ff9fd1fd3c6c958a77d71df5c0": "52add4eeb2a39468624a7a19618a0213",
".git/objects/3f/f3296cf696a75e2c3750b250a0f005e1335725": "d1795a5bdb75080934c1a3d9e1a4af01",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4f/908f395fc3e101b723572c5744b91072a35184": "bb323ddcc36c0c6a389c6f6cd0b8c815",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/53/4f0d724182655ea795f171e1e459b177ca23ee": "92072f7b5e7b4682d6e9f4309117f09e",
".git/objects/55/d0c0f9494811045e327515312e674cb71e60cc": "b8538febdb9c90afceb8a4164434e39a",
".git/objects/59/5226cf8fe1d3cfb0680571a01e8abbf8a187c9": "186fe0ac104aad56f7eb4bba2d2da4d3",
".git/objects/63/afbae9e1f5df8261653b358861ef257b8c75e7": "c743f025a9c9cd448261b606f415dbc3",
".git/objects/64/322f978948e39e645fd5802282d413a6c0642d": "0e1c5b6eec80e9fbf29bb031ebfc7f1b",
".git/objects/67/7ab5fe1fa842affa6760b9468d77a3ef02f3fd": "f162d8703d29d32a516881708c449554",
".git/objects/67/8cc85382405818768e0ad57bbd000a53940367": "b77d5108198edeada559d96208ce0dd0",
".git/objects/6f/5443046b421d35c81c20b3640ba925f826b160": "fbe2d3b357707a580d0f0a81c556f850",
".git/objects/73/43dbd00a874748cd096734d65532be6b8c8b4a": "53a3c185f89370d1130befb31e5a36d9",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/82/5e7e938ddd30d9affe7ccfac6c03439d48813f": "11db0492e2573986ca2980008008414b",
".git/objects/86/96e5dce5b57957cd18a4e2d23a2e764bac1fba": "30208178cd7f6fd37a87b3682e6b68b5",
".git/objects/87/7accf7d1e4bfaa1ef45225828cbb9e00a33021": "131153d6b97ee5a18532d83081657d42",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/3ea6f44f13479f2f1e24ff80c4bc236b25e1d0": "a85c59ce343117f940ed482fea30b74a",
".git/objects/8a/80af16bd6970bb24a5b29f40a8086b1f39b955": "96d42099e447b79c1069f9a987a521a9",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8d/8b665797dd10d766a81222010858b3cc91e4b5": "a5077425104c14d4034c9d247777687d",
".git/objects/90/02c677e06b26444a08b2ecfcc8eb08c0173bf7": "f319d1efe24347332722d5f247521a25",
".git/objects/97/2fdb21d65288719794ba9cc43b2911fb4df1c4": "fd7d951c0b5ea47666811f6ba0a518bb",
".git/objects/97/3bef892b6e2e2f688350d26a000dbf9eec5982": "28a313befef3c9e92ed698faea7b89f5",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/98/24c60d352999fe7113c6359f09a0140451a173": "c88ff06931caf73704c6ab62236a2724",
".git/objects/9a/a8de888872a0b21fe937af7bb449b1169aa5ff": "6be8d24321330dfa84d4ddfeb96303a3",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/9f/53d330d90bec6f9a02bf3999f5167798813ae5": "dc6cbdbcbb3a7dda7f88df49c18e28d4",
".git/objects/a0/5da2f45fda943ad73b3cdf1decca3e4a253db2": "010a4f8a48b156d95ce9919683fcc623",
".git/objects/a0/ca129eea5682b441c4a79630c931a9c04b6304": "4bf2784771a52f7239465dc7b29b2268",
".git/objects/a1/54b2b7086419c26c49c31df0900b2d65931159": "c0887493e7747bd891607855c6317e46",
".git/objects/a3/d3a52061f0bf7f1d26355f6a08fc147df01e04": "706ff51a460ef9cca6132f40a99247a6",
".git/objects/a5/ff1807dde49ac67dcc01a9221ae4eef0a82f23": "011b5eba1fd9b3fea54be7eaa2760fc3",
".git/objects/a9/a70fef00281f68405bfa9cc71971c3b53a7b63": "70d8b6e05021659f79d159d760e6cec7",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c8/e1038b06b3c36bea8b945182cb230d567c17c9": "8664ad5a336b099404236e72780505eb",
".git/objects/c9/5f016a8265061e2f5c520e6138718dec186c03": "1bbca6fc1e9417e2f2e12addf0eb048e",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/cb/4959f5fef987cd1039fc36416d73cb993c6ef9": "ae901ad59bb62fdd11421b9c5191e04f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/da/ec1870e3234eb47fc9ed665d30f0fccfe4c3b7": "e6b3a7437ebc69693c4fc1350a95e65b",
".git/objects/dd/aadc053160cc3dfb93b080afc62e94e48519b3": "3b6174513a85ef96b05de5bd70c806eb",
".git/objects/e3/e9ee754c75ae07cc3d19f9b8c1e656cc4946a1": "14066365125dcce5aec8eb1454f0d127",
".git/objects/e5/9fcf092c026022a6308180fdefa5a29dc11579": "9131f817dbcaf7a56e08fad634099581",
".git/objects/e8/490cafa9f581f45a931ea1b2aa740f511dc48c": "0838a3f7e8c374af6bc00191b614d008",
".git/objects/e9/723b82b6ec589e34d2381842a5b675e418f856": "be3fca2d844a314bb6ad7271c7bbf848",
".git/objects/ea/deab9cd512bbb57c9e7cb9c720d1e1ac452a75": "426c987735ae4824e2f07cff86ff347a",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/ef/4e6a5c0949bff498f370c264fd8151566ec5c7": "20b8c053ed62db25a7ad5f3a6bd8b6f5",
".git/objects/f0/c5cffb73f352bf99e61fcf3408c4cb367f2a20": "0341a133702f32045ba2605767142a57",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f9/fba0e9895ca515d73952478bb3ed038f42c30b": "754a2f310f694c55532fefa96744ee9c",
".git/objects/fb/0a52905b90ee6ab91089acca93935fb84a238e": "828f71debc05a6ae18fcfc4d75ed597b",
".git/objects/fb/2292b36fa3e3ca2d1a2cb2af6886e1c7260aa4": "2f21b5e1de899b1d0db353e988fd3a0d",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/fe/cd0a1ea1d1d04f5c7956d9c392ad8d525e0449": "4bc23732ecd8d65e03b26617416ebb51",
".git/objects/ff/cb3fda6f7b7d321f4a4e521188dabe19b6de37": "3d04665dc90252fb7bdd15430ab4ec99",
".git/refs/heads/gh-pages": "d7d30c218e97ec67bc39f331f73b197f",
".git/refs/remotes/origin/gh-pages": "d7d30c218e97ec67bc39f331f73b197f",
"apple-touch-icon.png": "780de033473e6303efa4db2719edaa81",
"assets/AssetManifest.bin": "64ce950a416e8e734d2f1506c17fa7b7",
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
"favicon.ico": "e6bee8a6d16e4d6b58547d2156618b3e",
"favicon.png": "0289af5f56bdda223a324e3b50f3b932",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "32c1fc37b4744c6f865c4285b3e44a92",
"icons/Icon-192.png": "0289af5f56bdda223a324e3b50f3b932",
"icons/Icon-512.png": "f5d892771ea3065e570cb33cd44b8504",
"icons/Icon-maskable-192.png": "62fc6122a50ee757e26731b835e2721d",
"icons/Icon-maskable-512.png": "556f15423c7427832c0b52462b2ae3ef",
"index.html": "40137116218a87af4566dba47b7162b6",
"/": "40137116218a87af4566dba47b7162b6",
"main.dart.js": "6c786f909d2f6003602adc2d5b2474ee",
"manifest.json": "bc838d6d761ee9ee7cc9dbc7787e5ba0",
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
