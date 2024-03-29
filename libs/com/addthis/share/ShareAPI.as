package com.addthis.share {
    		
    import flash.display.Sprite;
    import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
	import flash.system.System;
    
    /**
     * ShareAPI
     *
     * This class provides a wrapper over the AddThis Sharing Endpoints.
     * 
     * See http://www.addthis.com/help/sharing-api for additional information
     */ 
    public class ShareAPI extends Sprite {
        
        static public const ENDPOINT:String = "http://api.addthis.com/oexchange/0.8/forward";
        static private const DEFAULT_OPTIONS:Object = {
            'url'         : '',
            'swfurl'      : '',
            'width'       : -1,
            'height'      : -1,
            'title'       : '',
            'description' : '',
            'screenshot'  : '',
			'template' 	  : '',
			'shortener'   : 'bitly'
        };
        
        private var username:String;
        
        /**
         * Instantiate the wrapper for use.
         *  
         * username: your AddThis username (to enable proper analytics)
         */
        public function ShareAPI( username:String='' ) {
            super();
            this.username = username;
        }
        
        /**
         * Initiate the share process by sending the user's browser to the endpoint.  See http://www.addthis.com/help/sharing-api for additional information
         *
         * url: the URL to share (scraped for metadata as appropriate)
         * destination: the name of the destination, or "menu" to display all; see http://www.addthis.com/services/list for possible names
         * options: an object containing various additional options, as follows:
         *     standard options:
         *         title: content title; no default
         *         desc: content description; no default
         *     rich-content options (if specified, all are required):
         *         swfurl: URL of the SWF content to be shared; defaults to this swf
         *         width: SWF width; defaults to stage size
         *         height: SWF height; defaults to stage size
         *         image_src: preview image used on certain destinations (igoogle, etc); no default
         */
        public function share( url:String, destination:String = 'menu', options:Object = null ):void {
			var hasCodedPage:Boolean = System.useCodePage;

			System.useCodePage = true;

            options ||= {};
            var params:URLVariables = new URLVariables();
            
            for (var k:String in DEFAULT_OPTIONS)
                if ( DEFAULT_OPTIONS[k] || options[k] )
                    params[k] = options[k] || DEFAULT_OPTIONS[k];
            
            params.url = url;
            
            if ( stage ) {
                if ( params.width == -1 )
                    params.width = stage.stageWidth;
                
                if ( params.height == -1 )
                    params.height = stage.stageHeight;
            };

            if ( username )
                params.username = username;
            if ( destination == 'menu' )
                destination = '';

            var request:URLRequest = new URLRequest();
				request.url = ENDPOINT + (destination ? '/' + destination : '')  + '/offer';
				request.method = URLRequestMethod.POST;
				request.data = params;

			if ( destination.toLowerCase() == "facebook" && options.force ) {
				var forceUrl:String = "http://www.facebook.com/sharer.php?s=100";
				if( params.title ) forceUrl += "&p[title]=" + encodeURIComponent( params.title );
				if( params.description ) forceUrl += "&p[summary]=" + encodeURIComponent( params.description );
				if( params.url ) forceUrl += "&p[url]=" + encodeURIComponent( params.url );
				if( params.screenshot ) forceUrl += "&p[images][0]=" + encodeURIComponent( params.screenshot );

				 request = new URLRequest();
				 request.url = forceUrl;
			};

			if ( destination.toLowerCase() == "orkut" ) {
				request = new URLRequest();
				request.url = "http://promote.orkut.com/preview?lang=pt_BR&nt=orkut.com";
				if( params.title ) request.url += "&tt=" + encodeURIComponent( params.title );
				if( params.description ) request.url += "&cn=" + encodeURIComponent( params.description );
				if( params.url ) request.url += "&du=" + encodeURIComponent( params.url );
			};

			navigateToURL( request, '_blank' ); 

			System.useCodePage = hasCodedPage;
        };
    };
}