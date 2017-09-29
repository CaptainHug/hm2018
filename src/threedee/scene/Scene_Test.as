package threedee.scene 
{
	import away3d.entities.Mesh;
	import away3d.primitives.CubeGeometry;
	import threedee.Root3D;
	/**
	 * ...
	 * @author jrh
	 */
	public class Scene_Test extends SceneBase3D 
	{
		private var _mesh:Mesh;
		
		
		public function Scene_Test() 
		{
			super();
			
		}
		
		
		override public function init():void
		{
			_mesh = new Mesh(new CubeGeometry(20, 20, 20));
			addChild(_mesh);
			
			Root3D.Instance.view.camera.z = -100; 
			Root3D.Instance.view.camera.lookAt(_mesh.position);
		}
		
		
		override public function update():void
		{
			if (_paused) return;
			
			_ticks++;
			
			_mesh.rotationX += 0.2;
			_mesh.rotationY += 0.3;
			_mesh.rotationZ += 0.1;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}

}
