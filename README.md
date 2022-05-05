# AssignmentView


AssignmentView is a image loader which includes 20 image url. It aims to perform loadng process in an efficient way which is getting images from cache when available at cache, else getting from url and decoding it in some settings.

## Features
- ProgressView
- Settings
- Displaying each images loading time and display size
- Logging each loading time to HttpBin
- Generic Networking

## Settings
- Reset Cache
> It  provides removing all cache images.
```sh
SDImageCache.shared.clearMemory()
SDImageCache.shared.clearDisk()
```
- Loading Images as thumbnail or default
> It actualy performed in big images well, unnecessary to use in small images. It provides decoding some of big images like 10000 pixels in such cases which are unnecessary situation to load all of image. As referenced [here][tb]
```sh
context: [.imageThumbnailPixelSize: thumbnailSize])
```
thumbnail size is CGSize of image will display
- Downloading big images in low priority
> If image has 5 mb or 3 mb it will upload in low priority to speed up other images.
```sh
if urlString.split(separator: "-")[1] == "5mb.png" || urlString.split(separator: "-")[1] == "3mb.png"{
    return [.progressiveLoad,.lowPriority, .scaleDownLargeImages]
}else{
    return [.progressiveLoad ,.highPriority]
}
```
- Clean cache after terminating app
> As the document says whether or not to remove the expired disk data when application been terminated.
```sh
SDImageCacheConfig.default.shouldRemoveExpiredDataWhenTerminate = userDefaults.bool(forKey: "terminateCache")
```
- Clean cache after app moves to background
> As the document says whether or not to remove the expired disk data when application entering the background. 
```sh
SDImageCacheConfig.default.shouldRemoveExpiredDataWhenEnterBackground = userDefaults.bool(forKey: "backgroundCache")
```
- Allows using cache
> As the document says whether or not to remove the expired disk data when application entering the background. To block using cache we need to pass cache type to memory and block using memory cache.
```sh
SDImageCacheConfig.default.shouldCacheImagesInMemory = userDefaults.bool(forKey: "regularCache")

.originalStoreCacheType: isCacheEnabled ? SDImageCacheType.all.rawValue : SDImageCacheType.memory.rawValue
```

## Installation

Install the pods and run the app.

```sh
if M1 mac
arch -x86_64 pod install
else
pod install
```

## Pods

AssignmentView uses these pods
- 'SDWebImage'
> This framework provides to load images from cache or network in an efficient way with lots of custom settings.
- 'TinyConstraints'
> This framework provides to code layout in small words.






[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
    
   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>
   [tb]: <https://github.com/SDWebImage/SDWebImage/wiki/Advanced-Usage#thumbnail-decoding-550>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
