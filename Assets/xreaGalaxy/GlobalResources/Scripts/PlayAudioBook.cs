using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARSubsystems;

public class PlayAudioBook : MonoBehaviour
{
    // XR
    private TrackingState trackingState;

    // audios
    public LightweightBookHelper lightweightBookHelper;

    public AudioClip[] AudioList;
    public AudioSource audioSource;

    private int PageIndex = 0;
    private int MaxPage = 3;
    private float offset = 0.01f;
    private bool playNext = false;
    // Start is called before the first frame update
    void Start()
    {
        InitPlay();
    }

    private void InitPlay()
    {
        MaxPage = AudioList.Length;
        PageIndex = 0;
        audioSource.clip = AudioList[PageIndex];
        audioSource.Play();
        Debug.Log("audio length is: " + audioSource.clip.length);
        Debug.Log(offset + audioSource.clip.length);
        PageIndex++;
        Debug.Log("next index is: " + PageIndex);
        StartCoroutine(alertEnd());
    }

    private IEnumerator alertEnd()
    {
        Debug.Log("Start Waiting for" + audioSource.clip.length + offset);
        yield return new WaitForSeconds(audioSource.clip.length + offset);
        playNext = true;
        Debug.Log("end of Audio + playNext?" + playNext);
    }

    private void Update()
    {
        Debug.Log("trackingState : " + trackingState);

        if (playNext)
        {
            if (MaxPage > PageIndex)
            {
                Debug.Log("current index: " + PageIndex);
                lightweightBookHelper.NextPage();
                audioSource.clip = AudioList[PageIndex];
                audioSource.Play();
                Debug.Log("audio length is: " + audioSource.clip.length);
                StartCoroutine(alertEnd());
                PageIndex++;
                Debug.Log("next index is: " + PageIndex);
            } else
            {
                Debug.Log("Last Page");
                PageIndex = 0; // go back to beginning
                lightweightBookHelper.GoToPage(0);
            }
            playNext = false;
        }
        /**
        if((PageIndex == 0) && !audioSource.isPlaying)
        {
            InitPlay();
        }
        */
    }
}
