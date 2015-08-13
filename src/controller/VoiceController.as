package controller
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	

	public class VoiceController
	{
		private static var _controller:VoiceController;
		private var DATA_NAME :String = "VoiceInfo";
		public static var SOUND_DISABLE:Boolean = false;
		public static var MUSIC_DISABLE:Boolean = false;
		
		public static var SOUND_BUTTON:String = "button";
		public static var SOUND_HARVEST:String = "harvest";
		public static var SOUND_PLOW:String = "plow";
		public static var SOUND_SEED:String = "seed";
		public static var SOUND_WATER:String = "water";
		
		[Embed(source="/sound/sound.mp3")]
		private var SoundRack:Class;
		
		[Embed(source="/sound/button.mp3")]
		private var BottonSound:Class;
		
		[Embed(source="/sound/harvest.mp3")]
		private var HarvestSound:Class;
		
		[Embed(source="/sound/plow.mp3")]
		private var PlowSound:Class;
		
		[Embed(source="/sound/seed.mp3")]
		private var SeedSound:Class;
		
		[Embed(source="/sound/water.mp3")]
		private var WaterSound:Class;
		
		private var soundVec:Object = {button:BottonSound,harvest:HarvestSound,plow:PlowSound,seed:SeedSound,water:WaterSound};
		
		
		private var m_cSoundRack:Sound = (new SoundRack() as Sound);
		private var backChannel:SoundChannel;
		private var soundChannel:SoundChannel;
		
		public static function get instance():VoiceController
		{
			if(!_controller){
				_controller = new VoiceController();
			}
			return _controller;
		}
		public function VoiceController()
		{
			
		}
		
		public function init():void
		{
			var shareo:SharedObject  = SharedObject.getLocal(DATA_NAME,"/");
			if(shareo && shareo.data && shareo.data.obj){
				voiceInfo = shareo.data.obj;
			}
			SOUND_DISABLE = voiceInfo["sound"];
			MUSIC_DISABLE = voiceInfo["music"];
			playRack();
		}
		private var voiceInfo :Object = {music:true,sound:true};
		private function saveSoundInfo():void
		{
			var shareo:SharedObject = SharedObject.getLocal(DATA_NAME,"/");
			shareo.data.obj = voiceInfo;
			shareo.flush();
		}
		public function setMusic(bool:Boolean):void
		{
			MUSIC_DISABLE = bool;
			if(MUSIC_DISABLE){
				playRack();
			}else{
				closeRack();
			}
			voiceInfo["music"] = MUSIC_DISABLE;
			saveSoundInfo();
		}
		
		private var musicVoice:Number = 0.3;
		public function setMusicVoice(v:Number):void
		{
			musicVoice = v;
			if(backChannel){
				backChannel.soundTransform = new SoundTransform(musicVoice);
			}
		}
		public function setSound(bool:Boolean):void
		{
			SOUND_DISABLE = bool;
			voiceInfo["sound"] = SOUND_DISABLE;
			saveSoundInfo();
		}
		
		
		public function playRack(e:Event = null):void{
			if(MUSIC_DISABLE){
				if(!m_cSoundRack){
					m_cSoundRack = new SoundRack() as Sound;
				}
				if(backChannel){
					closeRack();
				}
				backChannel = m_cSoundRack.play();
				backChannel.soundTransform = new SoundTransform(musicVoice);
				backChannel.addEventListener(Event.SOUND_COMPLETE,onBackComplete,false,0,true);
			}
		}
		private function closeRack():void
		{
			backChannel.stop();
			backChannel.removeEventListener(Event.SOUND_COMPLETE,onBackComplete);
		}
		private function onBackComplete(e:Event):void
		{
			closeRack();
			
			setTimeout(playRack,2000);
		}
		public function tick():void
		{
			if(!m_cSoundRack){
				m_cSoundRack = new SoundRack() as Sound;
			}
			soundChannel
		}
		
		public function playSound(type:String):void
		{
			if(SOUND_DISABLE){
				var cls:Class = soundVec[type];
				var sound:Sound = new cls();
				
				var soundChannel:SoundChannel = sound.play();
				if(soundChannel){
					soundChannel.soundTransform = new SoundTransform(0.2);
				}
			}
		}
		
	}
}