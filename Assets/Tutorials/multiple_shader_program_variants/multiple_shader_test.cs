using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class multiple_shader_test : MonoBehaviour {
    Material m_material;
    private void Awake()
    {
        m_material = this.GetComponent<MeshRenderer>().sharedMaterial;
    }

    void ChangeKeyword(string keyword)
    {
        m_material.DisableKeyword("RED");
        m_material.DisableKeyword("GREEN");
        m_material.DisableKeyword("BLUE");

        m_material.EnableKeyword(keyword);
    }

    private void OnGUI()
    {
        if ( GUI.Button(new Rect(0, 0, Screen.width * 0.5f, Screen.height*0.3f), "RED"))
        {
            ChangeKeyword("RED");
        }

        if (GUI.Button(new Rect(0, Screen.height * 0.3f, Screen.width * 0.5f, Screen.height * 0.3f), "GREEN"))
        {
            ChangeKeyword("GREEN");
        }

        if (GUI.Button(new Rect(0, Screen.height * 0.6f, Screen.width * 0.5f, Screen.height * 0.3f), "BLUE"))
        {
            ChangeKeyword("BLUE");
        }
    }
}
