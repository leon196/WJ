using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Shader : MonoBehaviour
	{
		int currentShader;
		UnityEngine.Shader[] shaders;

		float delayBeforeNextShader = 5f;
		float timeSinceNewShader = 0f;

		Material materialEffect;

		void Start ()
		{
			currentShader = 0;

			Object[] objects = Resources.LoadAll("Gallery");
			shaders = new UnityEngine.Shader[objects.Length];
			for (int i = 0; i < objects.Length; ++i)
			{
				shaders[i] = objects[i] as UnityEngine.Shader;
			}

			materialEffect = GetComponentInChildren<Video>().GetComponent<Renderer>().material;
			materialEffect.shader = GetCurrentShader();

			timeSinceNewShader = Time.time;
		}
		
		void Update ()
		{
			UnityEngine.Shader.SetGlobalFloat("_TimeElapsed", Time.time);

			float timingRatio = Mathf.Clamp((Time.time - timeSinceNewShader) / delayBeforeNextShader, 0f, 1f);
			if (timingRatio >= 1f)
			{
				NextShader();
				materialEffect.shader = GetCurrentShader();
				timeSinceNewShader = Time.time;
			}
		}

		void NextShader ()
		{
			currentShader = (currentShader + 1) % shaders.Length;
		}

		UnityEngine.Shader GetCurrentShader ()
		{
			return shaders[currentShader];
		}

		void UpdateMaterial ()
		{

		}
	}
}