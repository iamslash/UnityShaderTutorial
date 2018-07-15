using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnableKeaword : MonoBehaviour {

    public void OnGUI() {
        KeywordButtonGUI("_Color_Red");
        KeywordButtonGUI("_Color_Blue");
        KeywordButtonGUI("_Color_Green");
    }

    private void KeywordButtonGUI(string keyword) {
        if (GUILayout.Button(keyword + " : ON"))
            Shader.EnableKeyword(keyword);
        if (GUILayout.Button(keyword + " : OFF"))
            Shader.DisableKeyword(keyword);
        GUILayout.Label(keyword + " Enabled : " + Shader.IsKeywordEnabled(keyword).ToString());
    }
}
