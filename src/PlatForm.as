package
{
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import service.command.payment.VertifyGooglePayCommand;

	public class PlatForm
	{
		public function PlatForm()
		{
			
		}
		public static function FormBuyItems(id:String):void
		{
			
			var object:Object = {"signedData":JSON.stringify({
						"orderId":SystemDate.systemTimeS,
						"packageName":"air.Farmland.andriod",
						"productId":id,
						"purchaseTime":1420546046853,
						"purchaseState":0,
						"purchaseToken":"fdcokkmfgoeilocdcgaolcfk.AO-J1Owc-YtBcc98aO542NNUIgCLdh-ONRhKHInV73PW1CjMLdnD7IXra1Xy9Sh8rYInBJPh98V_rkEkfTJTQfiHly6rjMhQ8j6ffNnYnj_uuHirgb-l-5qdkUqHgtskchvlp10QjXIJ"
							}),
					"signature":"k1D6xeqXDJ7ESuOczZLedO5ghuWgMD47eEiTNEcqZtDZ3MRFLcQ3pVcbAnx+KUoAjtlmwAwG\/nxHWcgVPQXWAybHmdd8SHrsMi+4EjQzQaW\/qOLcdw5YVuAYG3mFpvpfVM39ESO0EyhVzjw0o4Zr3JIOzlQ8gZ74wOdNd0jfC5\/i6pzqwu\/aP929DGNOy8Jy0uKmtbuO7aOcsB4Cl1UETV99ySOyjuhXexPBSTNiV0yp09HVmAj9oKZRiC\/Vn7YV5F6kp2iA\/6fqXrVl0wO5V0FgJH3J8bupoCleksGwr7+oSgBT9UaDMmFq0NMyYq\/JjD7f0wY00g1VrlSFh+j6+A=="}

			var signedData:String = JSON.stringify(object);
			
			new VertifyGooglePayCommand({'receipt':object,"receiptStr":signedData,"buytype":"localTest"},function():void{},function():void
			{
				//											InAppPurchase.getInstance().removePurchaseFromQueue(lastProId,_verifyPayStr);
				//											_verifyPayStr = null;
			});
			
		}
		public static function getProducts():void
		{
			trace("getProducts");
		}
		//score
		public static function submitScore(score:int):void
		{
			trace("no score");
		}
		
		//achieve
		
		public static function submitAchieve(achieve:String,process:int):void
		{
			trace("no achieve");
		}
		
		public static function share():void
		{
		}
		
		public static function showAD(type:int = 1):void
		{
			trace("no ad");
		}
		public static function hideAD():void
		{
			
		}
	}	
}