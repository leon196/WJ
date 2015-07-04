using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Main : MonoBehaviour
	{
		public bool cycleMode = false;

		Shader shader;
		RenderTexture renderTexture;
		Video video;

		void Start () 
		{
			shader = GetComponent<Shader>();
			renderTexture = GetComponentInChildren<RenderTexture>();
			video = GetComponentInChildren<Video>();
		}

		void Resize (float pixelSize)
		{
			if (renderTexture.PixelSize != pixelSize)
			{
				renderTexture.PixelSize = pixelSize;
				renderTexture.Resize();
			}
		}

		void Update ()
		{
			UnityEngine.Shader.SetGlobalFloat("_TimeElapsed", Time.time);

			if (cycleMode)
			{
				if (shader.IsItTimeToChange())
				{
					shader.NextShader();
					CheckSpecials();
				}
			}

			if (Input.GetKeyDown(KeyCode.RightArrow))
			{
				shader.NextShader();
				CheckSpecials();
			}

			if (Input.GetKeyDown(KeyCode.Escape))
			{
				Application.Quit();
			}
		}

		void CheckSpecials ()
		{
			if (shader.GetCurrentShader().name == "Custom/GlitchColorDirection"
				|| shader.GetCurrentShader().name == "Custom/GlitchFatPixel"
				|| shader.GetCurrentShader().name == "Custom/GlitchDistortion2"
				|| shader.GetCurrentShader().name == "Custom/GlitchDistortion3")
			{
				Resize(2f);
			}
			else 
			{
				Resize(1f);
			}
		}
	}
}
