using UnityEngine;
using System.Collections;

namespace WJ
{
	[ExecuteInEditMode]
	public class Shader : MonoBehaviour
	{
		void Start ()
		{
		}
		
		void Update ()
		{
			UnityEngine.Shader.SetGlobalFloat("_TimeElapsed", Time.time);
		}
	}
}