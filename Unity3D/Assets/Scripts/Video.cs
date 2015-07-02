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
			Debug.Log(objects.Length);
		}

		public void NextVideo ()
		{
			NextObject();
			MovieTexture video = GetCurrentVideo();
            video.loop = true;
            video.Play();
			materialEffect.SetTexture("_SamplerVideo", GetCurrentVideo());
			materialEffect.SetFloat("_RoundVideo", round);
		}

		public MovieTexture GetCurrentVideo ()
		{
			return GetCurrentObject() as MovieTexture;
		}
	}
}
