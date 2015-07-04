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

		void Start ()
		{
			audioSource = gameObject.AddComponent<AudioSource>();

			const int length = 64;

			samples = new float[length];
			samplesTexture = new Texture2D(length, 1, TextureFormat.ARGB32, false);
			samplesTotal = 0f;

			var url = "file://" + Application.dataPath + "/StreamingAssets/Hop.ogg";
			var www = new WWW(url);
			audioClip = www.audioClip;

			audioSource.clip = audioClip;

			UnityEngine.Shader.SetGlobalTexture("_SamplerSound", samplesTexture);
		}

	    void Update ()  
	    {
	        if (audioClip.isReadyToPlay && !audioSource.isPlaying)
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

			UnityEngine.Shader.SetGlobalFloat("_SamplesTotal", samplesTotal);
	    }
	}
}
