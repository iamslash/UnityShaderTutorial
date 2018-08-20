using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class basic_cull : MonoBehaviour {
	public Shader m_cull_back_shader;
	public Shader m_cull_front_shader;
	public Material m_target_material;

	void ChangeShader(bool is_cull_back ) {
		m_target_material.shader = is_cull_back ? m_cull_back_shader : m_cull_front_shader;
	}
	void OnGUI()
	{
		if ( GUI.Button(new Rect(0, Screen.height * 0.3f, Screen.width * 0.2f, Screen.height * 0.2f), "CULL FRONT")) {
			ChangeShader (false);
		}

		if ( GUI.Button(new Rect(0, Screen.height * 0.5f, Screen.width * 0.2f, Screen.height * 0.2f), "CULL BACK")) {
			ChangeShader (true);
		}
	}


}
