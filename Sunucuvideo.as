package  {
	// Yazan Çizen Hakan Hürriyet
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
	
	
	
	public class Sunucuvideo extends MovieClip {
		
		var NetCon:NetConnection;
		
		var NetStr:NetStream;
		var xml:XML;
		var xmlLoader = new URLLoader();
		
		
		
		
		
		public function Sunucuvideo() {
			// constructor code
			
			
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoaded);
			xmlLoader.load(new URLRequest("http://95.0.143.215/goruntu999.xml"));
			sesiKes(0);
		}
		function yayiniDurumu(yayinDurumDeger:Number)
			{
				return yayinDurumDeger;
			}
		
		
		
		
		function xmlLoaded(e:Event):void {
			xml = new XML(e.target.data);
			//rtmp://128.199.51.114/ist2_16
			trace(xml.fmsadresi[3]);
			if(yayiniDurumu(xml.fmsadresi[3]) == int(0))
			{
				trace ("Yayın Kapalı");
				gotoAndStop(1,"Scene 2");
				
				
			}
			else
			{
			rmtpBaglan(xml.fmsadresi[0]); //xml.fmsadresi[0]
			}
		}
		
		function getTextToDynamic(textIndex:String)
			{
				this.legalbant.legalbant_text.text = textIndex;
			}
		
		
		function NCBaglan(e:NetStatusEvent):void{
					
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					trace("Bağlantı Başarılı");
					
					legalbant.gotoAndPlay(2);
					getTextToDynamic(xml.fmsadresi[1]);
					yayinaBasla();
				break;
				case "NetStream.Publish.Start" :
					trace("publish startt");
					break;
				case "NetConnection.Connect.Rejected" :
					
					trace("Bağlantı isteği geri çevrildi");
					this.server_stat.text = 'Bağlantı isteği geri çevrildi';
					this.NetCon = null;
					break;
				case "NetConnection.Connect.Failed" :
					trace("Rtmp Sunucu Geçersiz");
					this.server_stat.text = "Rtmp Sunucu Geçersiz";
					this.NetCon = null;
					break;
					case "NetConnection.Connect.Closed" :
					trace("Sunucu Bağlantısı Kapandı");
					this.server_stat.text = "Sunucu Bağlantısı Kapandı";
					this.NetCon = null;
					break;
				
				default:
					trace(e.info.code + " | " + e.info.description);
				
			}
			
		}
		
		function sesiKes(deger:Number)
			{
				SoundMixer.soundTransform = new SoundTransform(deger);
			}
		
		function yayinaBasla()
			{
				this.NetStr = new NetStream(this.NetCon);
				this.sunucu_video.attachNetStream(this.NetStr);
				this.sunucu_video.smoothing = true;
				this.NetStr.play("user_1");
				
			}
		
		function istasyonGetir(istasyon:Number)
			{
				return istasyon;
			}
		
		
		function rmtpBaglan(fmsAdresi:String)
		{
			if	(this.NetCon == null)
			{
				
				this.NetCon = new NetConnection();
				NetCon.client = { onBWDone: function():void{} }; // onBwDone Hatasını gidermek için gerekli değil ama ekrana hatabasmıyor
				this.NetCon.addEventListener(NetStatusEvent.NET_STATUS,NCBaglan);
				this.NetCon.connect(fmsAdresi);
			}
		}
		
		
	}
	
}
