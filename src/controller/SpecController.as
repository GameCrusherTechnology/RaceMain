package controller
{
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.CastleItemSpec;
	import model.gameSpec.CharacterItemSpec;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.MapItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	
	
	public class SpecController
	{
		
		private var resourcesLoader:URLLoader;
		private static var control:SpecController;
		public static function get instance():SpecController
		{
			if(!control){
				control = new SpecController();
			}
 			return control;
		}
		public function SpecController()
		{
		}
		private var _itemMap:Dictionary;
		public function initXml(_xml:XML):void
		{
			var group_xml:XML;
			var item_xml:XML;
			var item:ItemSpec;
			var group_id:String;
			_itemMap = new Dictionary;
			for each(group_xml in _xml.Group)
			{
				group_id = group_xml.@id;
				_itemMap[group_id] = {};
				for each(item_xml in group_xml[group_id])
				{
					item = applyPropertiesFromXML(item_xml,group_id);
					item.group_id=group_id;
					_itemMap[group_id][item_xml.@item_id]=item;
				}
			}
			trace("initxml");
		}
		private function applyPropertiesFromXML(xml:XML,groupId:String):ItemSpec{
			var index:int =0 ;
			var xmlList:XMLList = xml.@*;
			var prop:String;
			var value:String;
			var groudCls:* = getSpecCls(groupId);
			var arg1:Object={};
			while (index < xmlList.length()) {
				prop=xmlList[index].name();
				value=xmlList[index].toString();
				try {
					if(value=="true"){
						arg1[prop]=true;
					}else if(value == "false"){
						arg1[prop]=false;
					}else if(parseInt(value).toString()==value){
						arg1[prop]=parseInt(value);
					}else if(parseFloat(value).toString()==value){
						arg1[prop]=parseFloat(value);
					}else{
						arg1[prop] =value;
					}
				} catch(e:Error) {
					
				}
				index++;
			}
			return new groudCls(arg1);
		}
		
		private function getSpecCls(name:String):Class
		{
			switch(name){
				case "Character":
					return CharacterItemSpec;
					break;
				case "Battle":
					return BattleItemSpec;
					break;
				case "Soldier":
					return SoldierItemSpec;
					break;
				case "Map":
					return MapItemSpec;
					break;
				case "Skill":
					return SkillItemSpec;
					break;
				case "Castle":
					return CastleItemSpec;
					break;
				case "Piece":
					return PieceItemSpec;
					break;
				case "Item":
					return ItemSpec;
					break;
				default:
					return ItemSpec;
			}
			return ItemSpec;
		}
		public function getGroup(groupid:String):Object
		{
			var groupDic:Object;
			try{
				groupDic = _itemMap[groupid];
			}catch(e:Error){
				trace("error ---- no this + groupid : " +groupid);
			}
			return groupDic;
		}
		public function getGroupArr(groupid:String):Array
		{
			var groupDic:Object;
			try{
				groupDic = _itemMap[groupid];
			}catch(e:Error){
				trace("error ---- no this + groupid : " +groupid);
			}
			var spec:ItemSpec;
			var dicArr:Array = [];
			for each(spec in groupDic){
				dicArr.push(spec);
			}
			dicArr.sortOn("item_id",Array.NUMERIC);
			return dicArr;
		}
		private function getGroupById(id:String):String
		{
			var group:String;
			var itemid:int = int(id);
			var type:int = Math.floor(itemid/10000);
			switch(type){
				case 1:
					group = "Character";
					break;
				case 2:
					group = "Battle";
					break;
				case 3:
					group = "Skill";
					break;
				case 4:
					group = "Map";
					break;
				case 5:
					group = "Soldier";
					break;
				case 6:
					group = "Castle";
					break;
				case 7:
					group = "Piece";
					break;
				case 8:
					group = "Item";
					break;
			}
			return group;
		}
		public function getItemSpec(id:String):ItemSpec
		{
			var item:ItemSpec;
			var groupId:String = getGroupById(id);
			try{
				item = _itemMap[groupId][id];
			}catch(e:Error){
				trace("error ---- no this item item id :"+id +"group_id : " +groupId);
			}
			return item;
		}
	}
}