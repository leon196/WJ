using UnityEngine;
using System.Collections;

namespace WJ
{
	public class RenderTexture : MonoBehaviour
	{
		Camera cameraRender;
		Material materialRender;

		Camera cameraDraw;
		Material materialDraw;

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
			currentTexture = 0;
			textures = new UnityEngine.RenderTexture[2];
			textures[0] = new UnityEngine.RenderTexture(Screen.width, Screen.height, 16, RenderTextureFormat.ARGB32);
			textures[1] = new UnityEngine.RenderTexture(Screen.width, Screen.height, 16, RenderTextureFormat.ARGB32);
			textures[0].Create();
			textures[1].Create();

			cameraRender = GetComponent<Camera>();
			materialRender = GetComponentInChildren<Renderer>().material;

			cameraDraw = Camera.main;
			materialDraw = cameraDraw.GetComponentInChildren<Renderer>().material;

			materialRender.SetTexture("_SamplerRenderTarget", GetCurrentTexture());
			NextTexture();
			cameraRender.targetTexture = GetCurrentTexture();
			materialDraw.mainTexture = GetCurrentTexture();
		}

		void Update ()
		{
			materialRender.SetTexture("_SamplerRenderTarget", GetCurrentTexture());
			NextTexture();
			cameraRender.targetTexture = GetCurrentTexture();
			materialDraw.mainTexture = GetCurrentTexture();
		}
	}
}