using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Sound : MonoBehaviour
	{
		AudioClip audioClip;
		AudioSource audioSource;
    	float[] samples;  
    	Texture2D samplesTexture;
    	float samplesTotal;
    	float samplesElapsed;

		void Start ()
		{
			samplesElapsed = 0f;
			const int length = 1024;
			samples = new float[length];
			samplesTexture = new Texture2D(length, 1, TextureFormat.ARGB32, false);
			samplesTotal = 0f;
			UnityEngine.Shader.SetGlobalTexture("_SamplerSound", samplesTexture);
			audioSource = gameObject.AddComponent<AudioSource>();
		// }

		// public void LoadAudioClip ()
		// {		
			var url = "file://" + Application.dataPath + "/StreamingAssets/CMYK - Moomin Loop No 1.ogg";
			var www = new WWW(url);
			audioClip = www.audioClip;
			// audioSource = gameObject.AddComponent<AudioSource>();
			audioSource.clip = audioClip;

		}

		public void SetAudioClip (AudioClip clip)
		{		
			audioClip = clip;
			audioSource.clip = clip;
		}

	    public void UpdateSamples ()  
	    {
	        if (audioClip.loadState == AudioDataLoadState.Loaded && !audioSource.isPlaying)
	        {      
	            audioSource.Play();
	        }          

	        audioSource.GetSpectrumData(samples, 0, FFTWindow.BlackmanHarris);

	        Color[] colors = samplesTexture.GetPixels(0);
	        samplesTotal = 0f;
	        for (int i = 0; i < samples.Length; ++i)
	        {
	        	float sample = samples[i];
	        	colors[i] = Color.white * sample;
	        	samplesTotal += sample;
	        }
			samplesTexture.SetPixels(colors, 0);
	        samplesTexture.Apply(false);

	        samplesElapsed += samplesTotal;

			UnityEngine.Shader.SetGlobalFloat("_SamplesTotal", samplesTotal);

			UnityEngine.Shader.SetGlobalFloat("_SamplesElapsed", samplesElapsed);
	    }
	}
}
