using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Video : Behaviour
	{
		Material materialEffect;

		void Start ()
		{
			delayBeforeNewObject = 5f;
			materialEffect = GetComponent<Renderer>().material;
			objects = Resources.FindObjectsOfTypeAll(typeof(MovieTexture));

			MovieTexture video = GetCurrentVideo();
            video.loop = true;
            video.Play();
		}

		public void NextVideo ()
		{
			NextObject();

			MovieTexture video = GetCurrentVideo();
            video.loop = true;
            video.Play();

			UnityEngine.Shader.SetGlobalTexture("_SamplerVideo", GetCurrentVideo());
			UnityEngine.Shader.SetGlobalFloat("_RoundVideo", round);
		}

		public MovieTexture GetCurrentVideo ()
		{
			return GetCurrentObject() as MovieTexture;
		}
	}
}
