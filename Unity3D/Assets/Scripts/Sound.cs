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
	        foreach (string device in Microphone.devices) {
	            Debug.Log("Name: " + device);
	        }

			samplesElapsed = 0f;
			const int length = 256;
			samples = new float[length];
			samplesTexture = new Texture2D(length, 1, TextureFormat.ARGB32, false);
			samplesTotal = 0f;
			UnityEngine.Shader.SetGlobalTexture("_SamplerSound", samplesTexture);
			audioSource = gameObject.AddComponent<AudioSource>();
			
			audioClip = Microphone.Start(Microphone.devices[0], true, 5, 24000);
			audioSource.clip = Microphone.Start(Microphone.devices[0], true, 5, 24000);

			    // audioObj[index].clip = ;


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

	        	// colors[i] = Color.white * sample;
	        	// samplesTotal += sample;

	        	if (sample > 0.0001f)
	        	{
	        		colors[i] = Color.white;
	        		samplesTotal += 1f;
	        	}
	        	else
	        	{
	        		colors[i] = Color.black;
	        	}
	        }
			samplesTexture.SetPixels(colors, 0);
	        samplesTexture.Apply(false);

	        samplesElapsed += samplesTotal;

			UnityEngine.Shader.SetGlobalFloat("_SamplesTotal", samplesTotal / (float)samples.Length);

			UnityEngine.Shader.SetGlobalFloat("_SamplesElapsed", samplesElapsed);
	    }
	}
}
