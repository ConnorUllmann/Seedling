package  
{
	import flash.net.*;
    
    public class GetURL{
        
        private var request:URLRequest;
        
        public function GetURL(url:String, target:String = '_blank'){
            
            request = new URLRequest(url);          
            navigateToURL(request, target);
            
        }
    }

}