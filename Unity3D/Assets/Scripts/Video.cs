using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Video : MonoBehaviour
	{
		bool isPlaying;
		MovieTexture movieTexture;
		Material materialEffect;

		void Start ()
		{
			materialEffect = GetComponent<Renderer>().material;

			var url = "file://" + Application.dataPath + "/StreamingAssets/movie.ogg";

			var www = new WWW(url);

			movieTexture = (MovieTexture)www.movie;
            movieTexture.loop = true;
	        movieTexture.Play();
	        isPlaying = true;

			UnityEngine.Shader.SetGlobalTexture("_SamplerVideo", movieTexture);
		}

	    void Update ()  
	    {
	        if (isPlaying && movieTexture.isReadyToPlay && !movieTexture.isPlaying)
	        {      
	            movieTexture.Play();
	        }          
	    }   

	    public void Toggle ()
	    {
	        if (movieTexture.isReadyToPlay)
	        {
	        	if (movieTexture.isPlaying)
	            {
	            	movieTexture.Pause();
	            }
	            else
	            {
	            	movieTexture.Play();
	            }
	            isPlaying = movieTexture.isPlaying;
	        }        
	    }

	    public void Play ()
	    {
	        if (movieTexture.isReadyToPlay && !movieTexture.isPlaying)
	        {      
	            movieTexture.Play();
	        }        
	    }

	    public void Pause ()
	    {
	        if (movieTexture.isReadyToPlay && movieTexture.isPlaying)
	        {      
	            movieTexture.Pause();
	        }        
	    }

	    public void Stop ()
	    {
	        if (movieTexture.isReadyToPlay && movieTexture.isPlaying)
	        {      
	            movieTexture.Stop();
	        }        
	    }
	}
}
