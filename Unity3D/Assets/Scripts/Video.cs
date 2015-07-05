using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Video : MonoBehaviour
	{
		public MovieTexture movieTexture;
		Material materialEffect;

		void Start ()
		{
			materialEffect = GetComponent<Renderer>().material;

			var url = "file://" + Application.dataPath + "/StreamingAssets/movie.ogg";

			var www = new WWW(url);

			movieTexture = (MovieTexture)www.movie;
            movieTexture.loop = true;
	        movieTexture.Play();

			UnityEngine.Shader.SetGlobalTexture("_SamplerVideo", movieTexture);
		} 
	}
}
