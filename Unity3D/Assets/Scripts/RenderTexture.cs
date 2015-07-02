using UnityEngine;
using System.Collections;

namespace WJ
{
	public class RenderTexture : MonoBehaviour
	{
		float _scale = 1f;
		public float Scale { get; set; }
		int width = 256;
		int height = 256;

		Camera cameraRender;
		Material materialRender;

		Camera cameraEffect;
		Material materialEffect;

		int currentTexture;
		UnityEngine.RenderTexture[] textures;

		void NextTexture ()
		{
			currentTexture = (currentTexture + 1) % 2;
		}

		UnityEngine.RenderTexture GetCurrentTexture ()
		{
			return textures[currentTexture];
		}

		void Start ()
		{
			width = (int)(Screen.width * Scale);
			height = (int)(Screen.height * Scale);

			currentTexture = 0;
			textures = new UnityEngine.RenderTexture[2];
			ResizeTextures();

			cameraRender = GetComponent<Camera>();
			materialRender = GetComponentInChildren<Renderer>().material;

			cameraEffect = Camera.main;
			materialEffect = cameraEffect.GetComponentInChildren<Renderer>().material;

			materialRender.SetTexture("_SamplerRenderTarget", GetCurrentTexture());
			NextTexture();
			cameraRender.targetTexture = GetCurrentTexture();
			materialEffect.mainTexture = GetCurrentTexture();

		}

		void Update ()
		{
			materialRender.SetTexture("_SamplerRenderTarget", GetCurrentTexture());
			NextTexture();
			cameraRender.targetTexture = GetCurrentTexture();
			materialEffect.mainTexture = GetCurrentTexture();
		}

		public void ResizeTextures ()
		{
			for (int i = 0; i < textures.Length; ++i)
			{
				if (textures[i])
				{
					textures[i].Release();
				}
				textures[i] = new UnityEngine.RenderTexture(width, height, 16, RenderTextureFormat.ARGB32);
				textures[i].Create();
				textures[i].filterMode = FilterMode.Point;
			}
		}
	}
}