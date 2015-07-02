using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Main : MonoBehaviour
	{
		public bool cycleMode = false;
		public int pixelSize = 1;

		Shader shader;
		RenderTexture renderTexture;
		Video video;

		void Start () 
		{
			shader = GetComponent<Shader>();
			renderTexture = GetComponentInChildren<RenderTexture>();
			video = GetComponentInChildren<Video>();

			renderTexture.Scale = 1f / (float)pixelSize;
		}

		void Update ()
		{
			shader.UpdateShaderUniforms();

			if (cycleMode)
			{
				if (shader.IsItTimeToChange())
				{
					shader.NextShader();

					if (shader.GetCurrentShader().name == "GlitchColotDirection")
					{

					}
				}

				if (video.IsItTimeToChange())
				{
					video.NextVideo();
				}
			}
		}
	}
}
