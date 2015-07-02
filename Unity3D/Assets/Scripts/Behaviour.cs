using UnityEngine;
using System.Collections;

namespace WJ
{
	public class Behaviour : MonoBehaviour
	{
		// Cycle through list of things (shader, videos)
		public UnityEngine.Object[] objects;
		public int currentObject;
		public int round;

		// Timing
		public float delayBeforeNewObject = 5f;
		public float timeSinceNewObject = 0f;

		// The ratio from 0 to 1 
		public float GetTimingRatio ()
		{
			return Mathf.Clamp((Time.time - delayBeforeNewObject) / timeSinceNewObject, 0f, 1f);
		}

		public bool IsItTimeToChange ()
		{
			return 1f <= (Time.time - delayBeforeNewObject) / timeSinceNewObject;
		}

		public void NextObject ()
		{
			currentObject = (currentObject + 1) % objects.Length;
			round += currentObject == 0 ? 1 : 0;
			timeSinceNewObject = Time.time;
		}

		public Object GetCurrentObject ()
		{
			return objects[currentObject];
		}
	}
}