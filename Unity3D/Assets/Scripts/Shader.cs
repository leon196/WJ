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
			
			objects = Resources.LoadAll("Gallery");
			materialEffect = GetComponentInChildren<Video>().GetComponent<Renderer>().material;
			
			UpdateShaderUniforms();
		}

		public UnityEngine.Shader GetCurrentShader ()
		{
			return GetCurrentObject() as UnityEngine.Shader;
		}

		public void NextShader ()
		{
			NextObject();
			materialEffect.shader = GetCurrentObject() as UnityEngine.Shader;
			materialEffect.SetFloat("_RoundShader", round);
		}

		public void UpdateShaderUniforms ()
		{
			UnityEngine.Shader.SetGlobalFloat("_TimeElapsed", Time.time);
		}
	}
}