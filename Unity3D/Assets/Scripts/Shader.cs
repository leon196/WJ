using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Shader : Behaviour
	{
		Material materialEffect;

		void Start ()
		{
			delayBeforeNewObject = 5f;
			
			objects = Resources.LoadAll("Shaders");
			materialEffect = GetComponentInChildren<Video>().GetComponent<Renderer>().material;

	    	UnityEngine.Shader.SetGlobalVector("_Eye", new Vector3(0f, 0f, -1.5f));
	    	UnityEngine.Shader.SetGlobalVector("_Front", new Vector3(0f, 0f, 1f));
	    	UnityEngine.Shader.SetGlobalVector("_Up", new Vector3(0f, 1f, 0f));
	    	UnityEngine.Shader.SetGlobalVector("_Right", new Vector3(1f, 0f, 0f));

	    	UnityEngine.Shader.SetGlobalVector("_ScaleUV", new Vector2(2f, 2f));
	    	UnityEngine.Shader.SetGlobalVector("_OffsetUV", new Vector2(0f, 0f));
			
	    	UnityEngine.Shader.SetGlobalFloat("_Repeat", 0f);
	    	UnityEngine.Shader.SetGlobalFloat("_DisplacementScale", 0.2f);
	    	UnityEngine.Shader.SetGlobalFloat("_PlanetRadius", 0.4f);

	    	UnityEngine.Shader.SetGlobalColor("_SkyColor", new Color(0.3f, 0.3f, 0.3f, 1.0f));
	    	UnityEngine.Shader.SetGlobalColor("_ShadowColor", new Color(0f, 0f, 0f, 1.0f));
	    	UnityEngine.Shader.SetGlobalColor("_GlowColor", new Color(1f, 1f, 1f, 1.0f));
		}

		public UnityEngine.Shader GetCurrentShader ()
		{
			return GetCurrentObject() as UnityEngine.Shader;
		}

		public void NextShader ()
		{
			NextObject();
			materialEffect.shader = GetCurrentObject() as UnityEngine.Shader;
			
			UnityEngine.Shader.SetGlobalFloat("_RoundShader", round);
			UnityEngine.Shader.SetGlobalFloat("_RatioBufferTreshold", 0.4f + 0.2f * Random.Range(0f, 1f));
			UnityEngine.Shader.SetGlobalFloat("_RatioRandom1", Random.Range(0f, 1f));
		}
	}
}