using System;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    [SerializeField] private AudioSource _embientSound;
    [SerializeField] private AudioSource _announcementSound;
    [SerializeField] private AudioClip _jumpsquareSound;

    [SerializeField] private AudioSource _sfxSource;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayAnnouncement()
    {
        _announcementSound.Play();
    }
    
    public void PlayAmbientSound()
    {
        _embientSound.Play();
    }

    public void DistortionAnnouncement()
    {
        _announcementSound.pitch = 0.5f;
    }

    public void NormalAnnouncement()
    {
        _announcementSound.pitch = 1f;
    }

    public void DistortionAmbient()
    {
        _embientSound.pitch = 2f;
    }

        public void NormalAmbient()
        {
            _embientSound.pitch = 1f;
    }

    internal void PlayJumpsquareSound()
    {
        _sfxSource.PlayOneShot(_jumpsquareSound);
    }
}
