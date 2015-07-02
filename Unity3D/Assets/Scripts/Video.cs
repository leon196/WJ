using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Video : MonoBehaviour
	{
		MovieTexture video;
		void Start () 
		{
			video = GetComponent<Renderer>().sharedMaterial.GetTexture("_SamplerVideo") as MovieTexture;
			video.loop = true;
			video.Play();
		}
	}
}
