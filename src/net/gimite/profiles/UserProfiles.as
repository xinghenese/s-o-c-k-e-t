package net.gimite.profiles
{
	/**
	 * @author Administrator
	 */
	public class UserProfiles
	{
		private static var INSTANCE:UserProfiles = null;
		
		private var _msuid:String = '20937936';
		private var _token:String = 'MloA-T5qlot78J9KdalBG5xggVNEKk8yOLxyU85FL607v9CM_pZDABaHypTioWJUE4PvUvreJXUNIGOpWDxyzciPxHQoJtCasKUkrcckr5KDNCIRnqRJU5wRvT-BNheriotAFtGaVEa9-YEBwcb6BRAJFAoqTrlKMKiUJGqwquY';
		private var _zip:String = '1';
		private var _version:String = '1.0';
		private var _app_version:String = '4.0';
		private var _device_type:String = '1';
		private var _device_name:String = 'Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_b0c56658-4c96-419d-aaba-68cc2ceb750d';
		
		
		public function UserProfiles(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():UserProfiles
		{
			if(INSTANCE == null){
				INSTANCE = new UserProfiles(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		public function get userId():String
		{
			return _msuid;
		}
		
		public function get token():String
		{
			return _token;
		}
		
		public function get zip():String
		{
			return _zip;
		}
		
		public function get version():String
		{
			return _version;
		}
		
		public function get deviceType():String
		{
			return _device_type;
		}
		
		public function get deviceName():String
		{
			return _msuid;
		}
		
		public function get appVersion():String
		{
			return _app_version;
		}
		
		public function get profile():Object
		{
			return {
				msuid: _msuid,
				zip: _zip,
				v: _version,
				ver: _app_version,
				dev: _device_type,
				token: _token, 
				devn: _device_name
			}
		}
	}
}

class SingletonEnforcer{}