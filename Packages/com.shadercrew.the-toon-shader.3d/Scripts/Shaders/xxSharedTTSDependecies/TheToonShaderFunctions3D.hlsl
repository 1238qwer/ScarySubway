#ifndef THETOONSHADER_FUNCTION
#define THETOONSHADER_FUNCTION








        

































struct GeneralStylingData
{
    half enableDistanceFade;
    float distanceFadeStartDistance;
    float distanceFadeFalloff;
    half adjustDistanceFadeValue;
    float distanceFadeValue;
};


struct StylingData
{
    half isEnabled;
    half style;
    half type;
    float4 color;
    float rotation;
    float rotationBetweenCells;
    float density;
    float offset;
    float size;
    float sizeControl;
    float sizeFalloff;
    float roundness;
    float roundnessFalloff;
    float hardness;
    float opacity;
    float opacityFalloff;


    float dashEnabled;
    float dashType;
    float dashLength;
    float dashDensity;
    float dashTransitionPosition;
    float dashTransitionSoftness;
    float dashRoundness;
    float dashOffset;
};

struct StylingRandomData
{
    float enableRandomizer;
    float perlinNoiseSize;
    float perlinNoiseSeed;
    float whiteNoiseSeed;
    
    float noiseIntensity;
    
    half spacingRandomMode;
    float spacingRandomIntensity;

    half opacityRandomMode; 
    float opacityRandomIntensity;

    half lengthRandomMode;
    float lengthRandomIntensity;

    half hardnessRandomMode;
    float hardnessRandomIntensity;

    half thicknessRandomMode; 
    float thicknesshRandomIntensity;
    
   
   

};

struct AdditionalStylingSpecularData
{
    
};

struct AdditionalStylingRimData
{
    
};

struct PositionAndBlendingData
{
    half position;
    half blending;
    half isInverted;
};

struct UVSets
{
    float2 uv0;
    float2 uv1;
    float2 uv2;
    float2 uv3;
};

struct UVSpaceData
{
    half drawSpace;
    half uvSet;
    half coordinateSystem;
    half polarCenterMode;
    float4 polarCenter;
    half sSCameraDistanceScaled;
    half anchorSSToObjectsOrigin;
};


struct NoiseSampleData
{
    float perlinNoise;
    
    
    float perlinNoiseFloored;
    float whiteNoise;
    float whiteNoiseFloored;
};

struct RequiredNoiseData
{
    bool perlinNoise;
    bool perlinNoiseFloored;
    bool whiteNoise;
    bool whiteNoiseFloored;
};


#define UNITY_TWO_PI        6.28318530718f

float shiftLinear(
float ll0, float lll0
)
{
    float llll0 = (ll0 - lll0) / max(lll0 + 1.0, 1e-6);
    float lllll0 = (ll0 - lll0) / max(1.0 - lll0, 1e-6);
    return lerp(llll0, lllll0, step(lll0, ll0)); 
}
float sum(
float3 lllllll0
)
{
    return dot(lllllll0, float3(1, 1, 1));
}
float invLerp(
float lllllllll0, float llllllllll0, float ll0
)
{
    return (ll0 - lllllllll0) / (llllllllll0 - lllllllll0);
}
float4 invLerp(
float4 lllllllll0, float4 llllllllll0, float4 ll0
)
{
    return (ll0 - lllllllll0) / (llllllllll0 - lllllllll0);
}
float remap(
float lllllllllllllllll0, float llllllllllllllllll0, float lllllllllllllllllll0, float llllllllllllllllllll0, float ll0
)
{
    float llllllllllllllllllllll0 = invLerp(lllllllllllllllll0, llllllllllllllllll0, ll0);
    return lerp(lllllllllllllllllll0, llllllllllllllllllll0, llllllllllllllllllllll0);
}
float2 GetScreenUV(
float2 llllllllllllllllllllllll0, float lllllllllllllllllllllllll0
)
{
#if _URP
    float4 llllllllllllllllllllllllll0 = TransformObjectToHClip(float3(0, 0, 0));
#else
    float4 llllllllllllllllllllllllll0 = UnityObjectToClipPos(float3(0, 0, 0));
#endif
    float2 llllllllllllllllllllllllllll0 = float2(llllllllllllllllllllllll0.x, llllllllllllllllllllllll0.y);
    float lllllllllllllllllllllllllllll0 = _ScreenParams.y / _ScreenParams.x;
    llllllllllllllllllllllllllll0.x -= llllllllllllllllllllllllll0.x / (llllllllllllllllllllllllll0.w);
    llllllllllllllllllllllllllll0.y -= llllllllllllllllllllllllll0.y / (llllllllllllllllllllllllll0.w);
    llllllllllllllllllllllllllll0.y *= lllllllllllllllllllllllllllll0;
    llllllllllllllllllllllllllll0 *= 1 / lllllllllllllllllllllllll0;
    llllllllllllllllllllllllllll0 *= llllllllllllllllllllllllll0.z;
    return llllllllllllllllllllllllllll0;
};
float2 toPolar(
float2 lllllllllllllllllllllllllllllll0
)
{
    float l1 = length(lllllllllllllllllllllllllllllll0);
    float ll1 = atan2(lllllllllllllllllllllllllllllll0.y, lllllllllllllllllllllllllllllll0.x);
    return float2(ll1 / UNITY_TWO_PI, l1);
}
float2 ConvertToDrawSpace(
#if _URP
    InputData inputData, 
#else
    float3 llll1,
    float3 lllll1,
#endif
float2 lllllllll1, UVSpaceData uvSpaceData, float4 llllllllllllllllllllllllllll0, UVSets uvSets
)
{
#if _URP
        float3 llll1 = inputData.positionWS;
        float3 lllll1 = inputData.normalWS;
#endif      
    if (uvSpaceData.drawSpace == 0)    
    {
        if (uvSpaceData.uvSet == 0.0)
        {
            lllllllll1 = uvSets.uv0;
        }
        else if (uvSpaceData.uvSet == 1.0)
        {
            lllllllll1 = uvSets.uv1;
        }
        else if (uvSpaceData.uvSet == 2.0)
        {
            lllllllll1 = uvSets.uv2;
        }
        else if (uvSpaceData.uvSet == 3.0)
        {
            lllllllll1 = uvSets.uv3;
        }
    }
    else if (uvSpaceData.drawSpace == 1)    
    {
        float4 llllllllllllllllllllllll0 = mul(UNITY_MATRIX_VP, float4(llll1, 1.0));
        float4 llllllllllllll1 = ComputeScreenPos(llllllllllllllllllllllll0);
        lllllllll1 = ((llllllllllllll1.xy) / llllllllllllll1.w); 
        if (uvSpaceData.anchorSSToObjectsOrigin)
        {
            float4 lllllllllllllll1 = mul(UNITY_MATRIX_VP, float4(_WorldSpaceCameraPos, 1.0));
            float2 llllllllllllllll1 = lllllllllllllll1.xy / lllllllllllllll1.w;
            float2 lllllllllllllllll1 = llllllllllllllllllllllllllll0.xy;
            lllllllll1 = lllllllll1 - lllllllllllllllll1; 
        }
    }
    else if (uvSpaceData.drawSpace == 2)    
    {
        float3 lllllllllllllllllll1 = abs(lllll1);
        if (lllllllllllllllllll1.x > lllllllllllllllllll1.y && lllllllllllllllllll1.x > lllllllllllllllllll1.z)
        {
            lllllllll1 = llll1.yz;
        }
        else if (lllllllllllllllllll1.y > lllllllllllllllllll1.z)
        {
            lllllllll1 = llll1.xz;
        }
        else
        {
            lllllllll1 = llll1.xy;
        }
    }
    if (uvSpaceData.coordinateSystem == 1) 
    {
        if (uvSpaceData.drawSpace == 1)
        {
            if (uvSpaceData.polarCenterMode == 0) 
            {
                lllllllll1.xy -= uvSpaceData.polarCenter.xy;
            }
            else 
            {
                uvSpaceData.polarCenter.a = 1;
                float4 llllllllllllllllllll1 = mul(UNITY_MATRIX_VP, uvSpaceData.polarCenter);
                float4 lllllllllllllllllllll1 = ComputeScreenPos(llllllllllllllllllll1);
                float2 llllllllllllllllllllll1 = lllllllllllllllllllll1.xy / lllllllllllllllllllll1.w;
                lllllllll1.xy -= llllllllllllllllllllll1;
            }
        }
        else
        {
            lllllllll1.xy -= uvSpaceData.polarCenter.xy;
        }
    }
    if (uvSpaceData.coordinateSystem == 1) 
    {
        lllllllll1 = toPolar(lllllllll1);
    }
    if (uvSpaceData.drawSpace == 1)
    {
        if (uvSpaceData.sSCameraDistanceScaled == 1)
        {
            float3 lllllllllllllllllllllll1 = mul(UNITY_MATRIX_M, float4(0, 0, 0, 1.0)).xyz;
            lllllllll1.xy *= distance(_WorldSpaceCameraPos, lllllllllllllllllllllll1);
        }
        float llllllllllllllllllllllll1 = _ScreenParams.x / _ScreenParams.y;
        lllllllll1.x *= llllllllllllllllllllllll1;
    }
    return lllllllll1;
}
float CalculateSpecularMaskSkipDot(
float llllllllllllllllllllllllll1, float3 lllllllllllllllllllllllllll1, float llllllllllllllllllllllllllll1, float lllllllllllllllllllllllllllll1, float llllllllllllllllllllllllllllll1
)
{
    float lllllllllllllllllllllllllllllll1 = 0;
    float l2 = (1 - (llllllllllllllllllllllllllll1)) * 10; 
    llllllllllllllllllllllllll1 = max(llllllllllllllllllllllllll1, 0); 
    float ll2 = pow(llllllllllllllllllllllllll1, l2 * l2);
    float lll2 = smoothstep(0.8, 0.8 + lllllllllllllllllllllllllllll1 / 1, ll2);
    lllllllllllllllllllllllllllllll1 = lll2 * llllllllllllllllllllllllllllll1 * 5;
    return lllllllllllllllllllllllllllllll1;
}
float CalculateSpecularMask(
float3 lllll2, float3 llllll2, float3 lllllllllllllllllllllllllll1, float llllllllllllllllllllllllllll1, float lllllllllllllllllllllllllllll1, float llllllllllllllllllllllllllllll1
)
{
    float lllllllllllllllllllllllllllllll1 = 0;
    float3 llllllllllll2 = normalize(llllll2 + lllllllllllllllllllllllllll1);
    float llllllllllllllllllllllllll1 = dot(lllll2, llllllllllll2);
    lllllllllllllllllllllllllllllll1 = CalculateSpecularMaskSkipDot(llllllllllllllllllllllllll1, lllllllllllllllllllllllllll1, llllllllllllllllllllllllllll1, lllllllllllllllllllllllllllll1, llllllllllllllllllllllllllllll1);
    return lllllllllllllllllllllllllllllll1;
}
float CalculateRimMask(
float3 lllllllllllllllllllllllllll3, float3 lllllllllllllllllllllllllll1, float lllllllllllllllllllllllllllll3, float llllllllllllllllllllllllllllll3, float llllllllllllllllllllllllllllll1,
                        half l4, half ll4, half lll4, float llll4
)
{
    float lllll4 = 0;
    float llllll4 = saturate(1 - dot(lllllllllllllllllllllllllll1, lllllllllllllllllllllllllll3));
    lllllllllllllllllllllllllllll3 = 1 - lllllllllllllllllllllllllllll3;
    float lllllll4 = smoothstep(saturate(lllllllllllllllllllllllllllll3 - llllllllllllllllllllllllllllll3), lllllllllllllllllllllllllllll3, llllll4);
    if ((l4 == 0 && llllllllllllllllllllllllllllll1 > 0.0 && ((llll4 >= 0 || ll4 == 0) || lll4 == 0))
    || (l4 == 1 && (llllllllllllllllllllllllllllll1 <= 0.0 || (llll4 <= 2 && ll4 == 1)))
    || l4 == 2)
    {
        if (l4 == 1)
        {
            float llllllll4 = llllllllllllllllllllllllllllll1;
            if (ll4)
            {
                if (llllllllllllllllllllllllllllll1 > 0)
                {
                    llllllllllllllllllllllllllllll1 *= llll4;
                }
            }
            {
                float lllllllll4 = 1 - abs(min(llllllllllllllllllllllllllllll1 * 2, 0)); 
                if (llllllll4 > 0)
                {
                    lllllllll4 = llll4;
                }
                lllll4 = lllllll4 * (1 - lllllllll4);
            }
        }
        else if (l4 == 0)
        {
            lllll4 = lllllll4 * (llllllllllllllllllllllllllllll1 * 2) * (llll4);
        }
        else if (l4 == 2)
        {
            lllll4 = lllllll4; 
        }
    }
    return lllll4;
}
float CalculateRimMask2(
float3 lllllllllllllllllllllllllll3, float3 lllllllllllllllllllllllllll1, float lllllllllllllllllllllllllllll3, float llllllllllllllllllllllllllllll3, float llllllllllllllllllllllllllllll1,
                        half l4, half ll4, half lll4, float llll4
)
{
    float lllll4 = 0;
    float llllll4 = saturate(1 - dot(lllllllllllllllllllllllllll1, lllllllllllllllllllllllllll3));
    lllllllllllllllllllllllllllll3 = 1 - lllllllllllllllllllllllllllll3;
    float lllllll4 = smoothstep(saturate(lllllllllllllllllllllllllllll3 - llllllllllllllllllllllllllllll3), lllllllllllllllllllllllllllll3, llllll4);
    if ((l4 == 0 && llllllllllllllllllllllllllllll1 > 0.0 && ((llll4 >= 0 || ll4 == 0) || lll4 == 0))
    || (l4 == 1 && (llllllllllllllllllllllllllllll1 <= 0.0 || (llll4 <= 2 && ll4 == 1)))
    || l4 == 2)
    {
        if (l4 == 1)
        {
            if (ll4)
            {
                lllll4 = lllllll4 * (1 - llll4);
            }
            else
            {
                float lllllllll4 = 1 - abs(min(llllllllllllllllllllllllllllll1 * 2, 0)); 
                float lllllll0 = lerp(0, lllllllll4 * 4, llllllllllllllllllllllllllllll3);
                lllll4 = lllllll4 * (1 - lllllllll4);
            }
        }
        else if (l4 == 2)
        {
            lllll4 = lllllll4; 
        }
        else
        {
            lllll4 = lllllll4 * (llllllllllllllllllllllllllllll1 * 2) * (llll4);
        }
    }
    return lllll4;
}
float2 RotateUV(
float2 lllllllll1, float ll1
)
{
    float llllllllllllllllllllllllllll4 = radians(ll1);
    float lllllllllllllllllllllllllllll4 = cos(llllllllllllllllllllllllllll4);
    float llllllllllllllllllllllllllllll4 = sin(llllllllllllllllllllllllllll4);
    float2 lllllllllllllllllllllllllllllll4;
    lllllllllllllllllllllllllllllll4.x = lllllllll1.x * lllllllllllllllllllllllllllll4 - lllllllll1.y * llllllllllllllllllllllllllllll4;
    lllllllllllllllllllllllllllllll4.y = lllllllll1.x * llllllllllllllllllllllllllllll4 + lllllllll1.y * lllllllllllllllllllllllllllll4;
    return lllllllllllllllllllllllllllllll4;
}
float2 RotateUVRadians(
float2 lllllllll1, float lll5
)
{
    float llllllllllllllllllllllllllll4 = lll5;
    float lllllllllllllllllllllllllllll4 = cos(llllllllllllllllllllllllllll4);
    float llllllllllllllllllllllllllllll4 = sin(llllllllllllllllllllllllllll4);
    float2 lllllllllllllllllllllllllllllll4;
    lllllllllllllllllllllllllllllll4.x = lllllllll1.x * lllllllllllllllllllllllllllll4 - lllllllll1.y * llllllllllllllllllllllllllllll4;
    lllllllllllllllllllllllllllllll4.y = lllllllll1.x * llllllllllllllllllllllllllllll4 + lllllllll1.y * lllllllllllllllllllllllllllll4;
    return lllllllllllllllllllllllllllllll4;
}
float CalculateHatchingDashContinuity(
float lllllllll5, float llllllllll5, float lllllllllll5
)
{
    float llllllllllll5 = saturate(lllllllllll5);
    float lllllllllllll5 = saturate(lllllllll5);
    float llllllllllllll5 = max(llllllllll5, 0.0001);
    float lllllllllllllll5 = saturate(lllllllllllll5 + llllllllllllll5);
    float llllllllllllllll5 = lllllllllllllll5 - lllllllllllll5;
    float lllllllllllllllll5 = 0.0;
    if (llllllllllllllll5 <= 0.0001)
    {
        lllllllllllllllll5 = step(lllllllllllll5, llllllllllll5);
    }
    else
    {
        lllllllllllllllll5 = smoothstep(lllllllllllll5, lllllllllllllll5, llllllllllll5);
    }
    lllllllllllllllll5 *= lllllllllllllllll5;
    return 1.0 - lllllllllllllllll5;
}
float CalculateHatchingDashSafeSpacingHalfWidth(
float lllllllllllllllllll5, float llllllllllllllllllll5, float lllllllllllllllllllll5, half llllllllllllllllllllll5
)
{
    float lllllllllllllllllllllll5 = max(lllllllllllllllllll5, 0.0);
    float llllllllllllllllllllllll5 = saturate(llllllllllllllllllll5);
    float lllllllllllllllllllllllll5 = lllllllllllllllllll5 * (1.0 - llllllllllllllllllllllll5);
    float llllllllllllllllllllllllll5 = llllllllllllllllllllll5 ? max(lllllllllllllllllllll5, 0.0) : 0.0;
    float lllllllllllllllllllllllllll5 = 0.002;
    lllllllllllllllllllllll5 += max(lllllllllllllllllllllllll5, llllllllllllllllllllllllll5) + lllllllllllllllllllllllllll5;
    return min(lllllllllllllllllllllll5, 0.499);
}
float CalculateHatching1DMaskFromDistance(
float lllllllllllllllllllllllllllll5, float llllllllllllllllllllllllllllll5, float llllllllllllllllllll5, float l6, float ll6, float lll6, half llllllllllllllllllllll5
)
{
    if (llllllllllllllllllllllllllllll5 <= 0.0)
    {
        return 0.0;
    }
    float llllllllllllllllllllllll5 = saturate(llllllllllllllllllll5);
    float llllll6 = 1.0 - step(llllllllllllllllllllllllllllll5, lllllllllllllllllllllllllllll5);
    float lllllll6 = llllllllllllllllllllllllllllll5 * (1.0 - llllllllllllllllllllllll5);
    float llllllll6 = llllllllllllllllllllll5 ? max(lll6, 0.0) : 0.0;
    if (abs(llllllllllllllllllllllllllllll5 - l6) < 0.00001 && abs(ll6 - 1.0) < 0.00001)
    {
        llllllll6 = 0.0;
    }
    if (!llllllllllllllllllllll5 || llllllll6 <= 0.0)
    {
        if (lllllll6 <= 0.000001)
        {
            return llllll6;
        }
        return 1.0 - smoothstep(llllllllllllllllllllllllllllll5 - lllllll6, llllllllllllllllllllllllllllll5, lllllllllllllllllllllllllllll5);
    }
    float lllllllll6 = max(lllllll6, min(llllllll6, llllllllllllllllllllllllllllll5));
    if (lllllllll6 <= 0.000001)
    {
        return llllll6;
    }
    return 1.0 - smoothstep(llllllllllllllllllllllllllllll5 - lllllllll6, llllllllllllllllllllllllllllll5, lllllllllllllllllllllllllllll5);
}
float ApplyHatchingDashMode(
float lllllllllll6, float llllllllllll6, float lllllllllllll6, float llllllllllllll6, float lllllllllllllll6, float llllllllllllllllllll5,
float lllllllllllllllllllll5, float llllllllllllllllll6, float lllllllllllllllllll6, float llllllllllllllllllll6, half llllllllllllllllllllll5
)
{
    if (llllllllllllll6 <= 0.0)
    {
        return lllllllllll6;
    }
    float llllllllllllllllllllll6 = max(0.0, 0.5 - lllllllllllllll6);
    float lllllllllllllllllllllll6 = 0.0;
    if (llllllllllllllllllllll6 > 0.00001)
    {
        lllllllllllllllllllllll6 = smoothstep(0.0, 0.001, llllllllllllllllllllll6);
    }
    if (lllllllllllllllllll6 < 0.5)
    {
        if (lllllllllllllllllllllll6 <= 0.0)
        {
            return lllllllllll6;
        }
        float llllllllllllllllllllllll6 = CalculateHatching1DMaskFromDistance(
            lllllllllllll6,
            lllllllllllllll6,
            llllllllllllllllllll5,
            -1.0,
            0.0,
            llllllllllllllllll6,
            llllllllllllllllllllll5
        );
        float lllllllllllllllllllllllll6 = lllllllllll6 * llllllllllllllllllllllll6;
        return lerp(lllllllllll6, lllllllllllllllllllllllll6, lllllllllllllllllllllll6);
    }
    float llllllllllllllllllllllllll6 = remap(
        0.0, 1.0,
        max(min(llllllllllllll6, max(lllllllllllllll6, 0.0001)), 0.0001),
        0.0001,
        saturate(llllllllllllllllllll5)
    );
    float lllllllllllllllllllllllllll6 = llllllllllllllllllllll5 ? max(llllllllllllllllll6, 0.0) : 0.0;
    llllllllllllllllllllllllll6 = max(llllllllllllllllllllllllll6, lllllllllllllllllllllllllll6 + 0.0001);
    float llllllllllllllllllllllllllll6 = 0.5 + llllllllllllllllllllllllll6;
    float lllllllllllllllllllllllllllll6 = lerp(llllllllllllllllllllllllllll6, lllllllllllllll6, lllllllllllllllllllllll6);
    float llllllllllllllllllllllllllllll6 = llllllllllllllllllll6 * lllllllllllllllllllllll6;
    float2 lllllllllllllllllllllllllllllll6 = float2(lllllllllllll6, llllllllllll6);
    float2 llllllllllllllllllllllllllllll5 = float2(max(lllllllllllllllllllllllllllll6, 0.0001), max(llllllllllllll6, 0.0001));
    float ll7 = max(min(llllllllllllllllllllllllllllll5.x, llllllllllllllllllllllllllllll5.y), 0.0001);
    float lllllllllllllllllllll3 = ll7 * saturate(llllllllllllllllllllllllllllll6);
    lllllllllllllllllllll3 = min(lllllllllllllllllllll3, min(llllllllllllllllllllllllllllll5.x, llllllllllllllllllllllllllllll5.y));
    float2 llll7 = abs(lllllllllllllllllllllllllllllll6) - (llllllllllllllllllllllllllllll5 - lllllllllllllllllllll3);
    float lllll7 = length(max(llll7, 0.0)) + min(max(llll7.x, llll7.y), 0.0) - lllllllllllllllllllll3;
    float llllllllllllllllllllllll5 = saturate(llllllllllllllllllll5);
    float llllll6 = 1.0 - step(0.0, lllll7);
    float lllllll6 = remap(
        0.0, 1.0,
        ll7,
        0.0,
        llllllllllllllllllllllll5
    );
    if (!llllllllllllllllllllll5)
    {
        if (lllllll6 <= 0.000001)
        {
            return llllll6;
        }
        return 1.0 - smoothstep(0.0, lllllll6, lllll7);
    }
    float2 lllllllll7 = float2(max(llllllllllllllllll6, 0.0), max(lllllllllllllllllllll5, 0.0));
    float2 llllllllll7;
    if (llll7.x > 0.0 && llll7.y > 0.0)
    {
        float2 lllllllllll7 = max(llll7, 0.0);
        llllllllll7 = lllllllllll7 / max(length(lllllllllll7), 0.0001);
    }
    else
    {
        llllllllll7 = (llll7.x > llll7.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
    }
    float llllllll6 = min(dot(llllllllll7, lllllllll7), ll7);
    if (llllllll6 <= 0.000001)
    {
        if (lllllll6 <= 0.000001)
        {
            return llllll6;
        }
        return 1.0 - smoothstep(0.0, lllllll6, lllll7);
    }
    if (lllllll6 >= llllllll6)
    {
        return 1.0 - smoothstep(0.0, lllllll6, lllll7);
    }
    float lllllllllllll7 = saturate(lllllll6 / llllllll6);
    float llllllllllllll7 = lerp(-llllllll6, 0.0, lllllllllllll7);
    float lllllllllllllll7 = llllllll6;
    return 1.0 - smoothstep(llllllllllllll7, lllllllllllllll7, lllll7);
}
NoiseSampleData SampleNoiseData(
float2 lllllllll1, StylingData stylingData, StylingRandomData stylingRandomData, RequiredNoiseData requiredNoiseData,
#ifdef USE_UNITY_TEXTURE_2D_TYPE
    UnityTexture2D lllllllllllllllll7, UnityTexture2D llllllllllllllllll7
#else
    sampler2D lllllllllllllllll7, sampler2D llllllllllllllllll7
#endif
)
{
    NoiseSampleData noiseSampleData;
    if (stylingRandomData.enableRandomizer == 1)
    {
        if (stylingData.style == 1)
        {
            if (fmod(floor(lllllllll1.y * stylingData.density), 2) == 0)
            {
                lllllllll1.x += stylingData.offset / stylingData.density;
            }
        }
        float lllllllllllllllllll7 = 0;
        if (requiredNoiseData.perlinNoiseFloored == 1)
        {
            float2 llllllllllllllllllll7 = lllllllll1;
            llllllllllllllllllll7.x = floor(lllllllll1.x * stylingData.density) / stylingData.density;
            if (stylingData.style == 1)
            {
                llllllllllllllllllll7.y = floor(lllllllll1.y * stylingData.density) / stylingData.density;
            }
            llllllllllllllllllll7 *= stylingRandomData.perlinNoiseSize;
            lllllllllllllllllll7 = tex2Dlod(lllllllllllllllll7, float4(llllllllllllllllllll7, 0.0, 0.0)).x;
        }
        float lllllllllllllllllllll7 = 0;
        if (requiredNoiseData.perlinNoise == 1)
        {
            float2 llllllllllllllllllllll7 = lllllllll1 * stylingRandomData.perlinNoiseSize;
            lllllllllllllllllllll7 = tex2Dlod(lllllllllllllllll7, float4(llllllllllllllllllllll7, 0.0, 0.0)).x; 
        }
        float lllllllllllllllllllllll7 = 0;
        if (requiredNoiseData.whiteNoise == 1)
        {
            float2 llllllllllllllllllllllll7 = lllllllll1;
            llllllllllllllllllllllll7.x = floor(lllllllll1.x * stylingData.density) / stylingData.density;
            if (stylingData.style == 0)
            {
                llllllllllllllllllllllll7.y = 0.1;
            }
            else if (stylingData.style == 1)
            {
                llllllllllllllllllllllll7.y = floor(lllllllll1.y * stylingData.density) / stylingData.density;
            }
            lllllllllllllllllllllll7 = tex2Dlod(llllllllllllllllll7, float4(llllllllllllllllllllllll7, 0.0, 0.0)).x; 
        }
        float lllllllllllllllllllllllll7 = 0;
        if (requiredNoiseData.whiteNoiseFloored == 1)
        {
            float2 llllllllllllllllllllllllll7 = lllllllll1;
            llllllllllllllllllllllllll7.x = floor(lllllllll1.x * stylingData.density) / stylingData.density;
            if (stylingData.style == 0)
            {
                llllllllllllllllllllllllll7.y = 0.1;
            }
            else if (stylingData.style == 1)
            {
                llllllllllllllllllllllllll7.y = 0.1;
            }
            lllllllllllllllllllllllll7 = tex2Dlod(llllllllllllllllll7, float4(llllllllllllllllllllllllll7, 0.0, 0.0)).x; 
        }
        noiseSampleData.perlinNoise = lllllllllllllllllllll7;
        noiseSampleData.perlinNoiseFloored = lllllllllllllllllll7;
        noiseSampleData.whiteNoise = lllllllllllllllllllllll7;
        noiseSampleData.whiteNoiseFloored = lllllllllllllllllllllllll7;
    }
    else
    {
        noiseSampleData.perlinNoise = 0;
        noiseSampleData.perlinNoiseFloored = 0;
        noiseSampleData.whiteNoise = 0;
        noiseSampleData.whiteNoiseFloored = 0;
    }
    return noiseSampleData;
}
float Hatching(
float ll0, float2 lllllllll1, StylingData hatchingData, StylingRandomData stylingRandomData, NoiseSampleData noiseSampleData, half llllllllllllllllllllllllllllll7
)
{
    ll0 = 1 - ll0;
    float2 lllllllllllllllllllllllllllllll7 = lllllllll1;
    float lllllllllllllllllll5 = hatchingData.size / 2;
    float ll8 = lllllllllllllllllllllllllllllll7.x;
    float lll8 = lllllllllllllllllllllllllllllll7.y; 
    float llll8 = max(hatchingData.dashDensity, 0.0001);
    ll8 *= hatchingData.density;
    lll8 *= llll8; 
    float lllll8 = floor(ll8); 
    float llllll8 = lll8; 
    float lllllll8 = llllllllllllllllllllllllllllll7 ? fwidth(ll8) : 0.0;
    if (stylingRandomData.enableRandomizer == 1)
    {
        ll8 += noiseSampleData.perlinNoise * stylingRandomData.noiseIntensity;
        lll8 += noiseSampleData.perlinNoise * stylingRandomData.noiseIntensity; 
        llllll8 = lll8; 
        lllllll8 = llllllllllllllllllllllllllllll7 ? fwidth(ll8) : 0.0;
        float llllllll8 = 0;
        if (stylingRandomData.thicknessRandomMode == 0)
        {
            llllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.thicknessRandomMode == 1) 
        {
            llllllll8 = noiseSampleData.perlinNoiseFloored;
        }
        else 
        {
            llllllll8 = ((noiseSampleData.perlinNoiseFloored) + noiseSampleData.whiteNoise) / 2;
        }
        llllllll8 *= stylingRandomData.thicknesshRandomIntensity;
        float lllllllll8 = remap(0, 1, 0.0, lllllllllllllllllll5, llllllll8);
        lllllllllllllllllll5 -= lllllllll8;
        float llllllllll8 = 0;
        if (stylingRandomData.spacingRandomMode == 0)
        {
            llllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.spacingRandomMode == 1) 
        {
            llllllllll8 = noiseSampleData.perlinNoiseFloored;
        }
        else 
        {
            llllllllll8 = ((noiseSampleData.perlinNoiseFloored) + noiseSampleData.whiteNoise) / 2;
        }
        float lllllllllll8 = lllllllllllllllllll5;
        if (hatchingData.style == 0 && hatchingData.dashEnabled == 1 && hatchingData.dashType == 1)
        {
            lllllllllll8 = CalculateHatchingDashSafeSpacingHalfWidth(
                lllllllllllllllllll5,
                hatchingData.hardness,
                lllllll8,
                llllllllllllllllllllllllllllll7
            );
        }
        float llllllllllll8 = remap(0, 1, -0.5 + lllllllllll8, 0.5 - lllllllllll8, llllllllll8);
        ll8 += llllllllllll8 * stylingRandomData.spacingRandomIntensity * saturate(1 - stylingRandomData.noiseIntensity); 
    }
    ll8 = abs(frac(ll8) - 0.5);
    float lllllllllll5 = 0;
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllllllllll8 = 0;
        if (stylingRandomData.lengthRandomMode == 0)
        {
            llllllllllllll8 = noiseSampleData.whiteNoise * saturate(1 - stylingRandomData.noiseIntensity); 
        }
        else if (stylingRandomData.lengthRandomMode == 1)
        {
            llllllllllllll8 = noiseSampleData.perlinNoiseFloored; 
        }
        else
        {
            llllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + (noiseSampleData.whiteNoise * saturate(1 - stylingRandomData.noiseIntensity))) / 2); 
        }
        float lllllllllllllll8 = llllllllllllll8 * stylingRandomData.lengthRandomIntensity;
        lllllllllll5 = remap(0, 1 - lllllllllllllll8, 0, 1, ll0);
    }
    else
    {
        lllllllllll5 = remap(0, 1, 0, 1, ll0);
    }
    float llllllllllllllll8 = smoothstep(min(1 - hatchingData.sizeFalloff, 0.99), 1, lllllllllll5);
    llllllllllllllll8 = max(lllllllllllllllllll5 - llllllllllllllll8, 0);
    float lllllllllllllllll8 = hatchingData.hardness; 
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllllllllllllll8 = 0;
        if (stylingRandomData.hardnessRandomMode == 0) 
        {
            llllllllllllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.hardnessRandomMode == 1) 
        {
            llllllllllllllllll8 = noiseSampleData.perlinNoiseFloored * 5;
        }
        else
        {
            llllllllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + noiseSampleData.whiteNoise) / 2) * 5;
        }
        lllllllllllllllll8 = min(saturate(hatchingData.hardness - llllllllllllllllll8 * stylingRandomData.hardnessRandomIntensity), hatchingData.hardness); 
    }
    float llllllllllll6 = ll8; 
    ll8 = CalculateHatching1DMaskFromDistance( 
        llllllllllll6,
        llllllllllllllll8,
        lllllllllllllllll8,
        lllllllllllllllllll5,
        hatchingData.size,
        lllllll8,
        llllllllllllllllllllllllllllll7
    );
    if (hatchingData.style == 0 && hatchingData.dashEnabled == 1)
    {
        float llllllllllllllllllll8 = CalculateHatchingDashContinuity(
            hatchingData.dashTransitionPosition,
            hatchingData.dashTransitionSoftness,
            lllllllllll5
        ); 
        float lllllllllllllllllllll8 = saturate(hatchingData.dashLength) * 0.5; 
        float lllllllllllllll6 = lerp(lllllllllllllllllllll8, 0.5, llllllllllllllllllll8); 
        lll8 += lllll8 * saturate(hatchingData.dashOffset); 
        float lllllllllllllllllllllll8 = llllllllllllllllllllllllllllll7 ? fwidth(llllll8) : 0.0; 
        float lllllllllllll6 = abs(frac(lll8) - 0.5); 
        ll8 = ApplyHatchingDashMode( 
            ll8,
            llllllllllll6,
            lllllllllllll6,
            llllllllllllllll8,
            lllllllllllllll6,
            lllllllllllllllll8,
            lllllll8,
            lllllllllllllllllllllll8,
            hatchingData.dashType,
            hatchingData.dashRoundness,
            llllllllllllllllllllllllllllll7
        );
    }
    if (stylingRandomData.enableRandomizer == 1)
    {
        float lllllllllllllllllllllllll8;
        if (stylingRandomData.opacityRandomMode == 0) 
        {
            lllllllllllllllllllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.opacityRandomMode == 1) 
        {
            lllllllllllllllllllllllll8 = noiseSampleData.perlinNoiseFloored * 5;
        }
        else 
        {
            lllllllllllllllllllllllll8 = ((noiseSampleData.perlinNoiseFloored * 5) + noiseSampleData.whiteNoise) / 2;
            lllllllllllllllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + noiseSampleData.whiteNoise) / 2) * 5;
        }
        ll8 = saturate(ll8 - (lllllllllllllllllllllllll8 * stylingRandomData.opacityRandomIntensity));
    }
    float llllllllllllllllllllllllll8 = smoothstep(min(1 - hatchingData.opacityFalloff, 0.99), 1, lllllllllll5);
    ll8 *= 1 - llllllllllllllllllllllllll8;
    ll8 *= hatchingData.opacity;
    return ll8;
}
float Halftones(
float ll0, float2 lllllllll1, StylingData halftonesData, StylingRandomData stylingRandomData, NoiseSampleData noiseSampleData
)
{
    float2 llllllllllllllllllllllllllllll8 = lllllllll1;
    llllllllllllllllllllllllllllll8 *= halftonesData.density;
    if (stylingRandomData.enableRandomizer == 1)
    {
        llllllllllllllllllllllllllllll8 += noiseSampleData.perlinNoise * stylingRandomData.noiseIntensity;
    }
    if (fmod(floor(llllllllllllllllllllllllllllll8.y), 2) == 0)
    {
        llllllllllllllllllllllllllllll8.x += halftonesData.offset;
    }
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllllllllll8 = 0;
        if (stylingRandomData.lengthRandomMode == 0)
        {
            llllllllllllll8 = noiseSampleData.whiteNoiseFloored * saturate(1 - stylingRandomData.noiseIntensity); 
        }
        else if (stylingRandomData.lengthRandomMode == 1)
        {
            llllllllllllll8 = noiseSampleData.perlinNoise; 
        }
        else
        {
            llllllllllllll8 = ((noiseSampleData.perlinNoise + (noiseSampleData.whiteNoise * saturate(1 - stylingRandomData.noiseIntensity))) / 2); 
        }
        float lllllllllllllll8 = llllllllllllll8 * stylingRandomData.lengthRandomIntensity;
        ll0 -= lllllllllllllll8;
    }
    float ll9 = halftonesData.size;
    if (halftonesData.sizeControl == 1)  
    {
        ll9 *= ll0;
    }
    else
    {
        float lll9 = smoothstep(min(1 - halftonesData.sizeFalloff, 1), 1, (1 - ll0)); 
        ll9 = max(ll9 - lll9, 0);
    }
    ll9 /= 2;
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllll8 = 0;
        if (stylingRandomData.thicknessRandomMode == 0)
        {
            llllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.thicknessRandomMode == 1) 
        {
            llllllll8 = noiseSampleData.perlinNoise;
        }
        else 
        {
            llllllll8 = ((noiseSampleData.perlinNoise) + noiseSampleData.whiteNoise) / 2;
        }
        float lllll9 = remap(0, 1, 0.0, ll9, llllllll8 * stylingRandomData.thicknesshRandomIntensity);
        ll9 -= lllll9;
    }
    float llllll9 = 1 - halftonesData.roundness;
    float lllllll9 = smoothstep(halftonesData.roundnessFalloff, 1, 1 - ll0);
    llllll9 = max(llllll9 - lllllll9 * 4, 0);
    llllll9 /= 2;
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllllll8 = 0;
        if (stylingRandomData.spacingRandomMode == 0)
        {
            llllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.spacingRandomMode == 1) 
        {
            llllllllll8 = noiseSampleData.perlinNoise;
        }
        else 
        {
            llllllllll8 = ((noiseSampleData.perlinNoise) + noiseSampleData.whiteNoise) / 2;
        }
        float llllllllllll8 = remap(0, 1, -0.5 + ll9, 0.5 - ll9, llllllllll8);
        llllllllllllllllllllllllllllll8 += llllllllllll8 * stylingRandomData.spacingRandomIntensity * saturate(1 - stylingRandomData.noiseIntensity); 
    }
    float llllllllll9 = halftonesData.hardness;
    if (stylingRandomData.enableRandomizer == 1)
    {
        float llllllllllllllllll8 = 0;
        if (stylingRandomData.hardnessRandomMode == 0) 
        {
            llllllllllllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.hardnessRandomMode == 1) 
        {
            llllllllllllllllll8 = noiseSampleData.perlinNoise * 5;
        }
        else
        {
            llllllllllllllllll8 = ((noiseSampleData.perlinNoise + noiseSampleData.whiteNoise) / 2) * 5;
        }
        llllllllll9 = min(saturate(halftonesData.hardness - llllllllllllllllll8 * stylingRandomData.hardnessRandomIntensity), halftonesData.hardness);
    }
    float llllllllllll9 = remap(0, 1, 0, ll9, llllllllll9);
    float l1 = length(max(abs(frac(llllllllllllllllllllllllllllll8) - 0.5) - llllll9 * llllllllllll9 * 2, 0.0)) + llllll9 * llllllllllll9 * 2;
    float llllllllllllll9 = smoothstep(llllllllllll9, ll9, l1);
    llllllllllllll9 = 1 - llllllllllllll9;
    if (stylingRandomData.enableRandomizer == 1)
    {
        float lllllllllllllllllllllllll8;
        if (stylingRandomData.opacityRandomMode == 0) 
        {
            lllllllllllllllllllllllll8 = noiseSampleData.whiteNoise;
        }
        else if (stylingRandomData.opacityRandomMode == 1) 
        {
            lllllllllllllllllllllllll8 = noiseSampleData.perlinNoise * 5;
        }
        else 
        {
            lllllllllllllllllllllllll8 = ((noiseSampleData.perlinNoise * 5) + noiseSampleData.whiteNoise) / 2;
            lllllllllllllllllllllllll8 = ((noiseSampleData.perlinNoise + noiseSampleData.whiteNoise) / 2) * 5;
        }
        llllllllllllll9 = saturate(llllllllllllll9 - (lllllllllllllllllllllllll8 * stylingRandomData.opacityRandomIntensity));
    }
    float llllllllllllllll9 = smoothstep(min(1 - halftonesData.opacityFalloff, 0.99), 1, 1 - ll0);
    if (halftonesData.type == 1 || halftonesData.opacityFalloff != 0)
    {
        llllllllllllll9 *= 1 - llllllllllllllll9;
    }
    llllllllllllll9 *= halftonesData.opacity;
    llllllllllllll9 = 1 - llllllllllllll9;
    return llllllllllllll9;
}
void DoBlending(
inout float4 lllllllllllllllll9, float ll0, float lllllllllllllllllll9, float4 llllllllllllllllllll9
)
{
    if (lllllllllllllllllll9 == 0) 
    {
        lllllllllllllllll9 = lerp(lllllllllllllllll9, llllllllllllllllllll9, ll0);
    }
    else if (lllllllllllllllllll9 == 1) 
    {
        lllllllllllllllll9 += (llllllllllllllllllll9 * ll0);
    }
    else if (lllllllllllllllllll9 == 2) 
    {
        lllllllllllllllll9 *= 1 - ll0 + (llllllllllllllllllll9 * ll0); 
    }
    else if (lllllllllllllllllll9 == 3) 
    {
        lllllllllllllllll9 -= (llllllllllllllllllll9 * ll0);
    }
    else if (lllllllllllllllllll9 == 4) 
    {
        lllllllllllllllll9 += llllllllllllllllllll9 * (1.0 - lllllllllllllllll9) * ll0;
    }
    else if (lllllllllllllllllll9 == 5) 
    {
        float4 lllllllllllllllllllll9 = 2.0 * llllllllllllllllllll9 - 1.0;
        float4 llllllllllllllllllllll9 = lllllllllllllllll9 * lllllllllllllllllllll9;
        float4 lllllllllllllllllllllll9 = (1.0 - lllllllllllllllll9) * lllllllllllllllllllll9;
        lllllllllllllllll9 += lerp(llllllllllllllllllllll9, lllllllllllllllllllllll9, step(0.5, lllllllllllllllll9)) * ll0;
    }
    else if (lllllllllllllllllll9 == 6) 
    {
        lllllllllllllllll9 += (2.0 * llllllllllllllllllll9 - 1.0) * lllllllllllllllll9 * (1.0 - lllllllllllllllll9) * ll0;
    }
    else if (lllllllllllllllllll9 == 7) 
    {
        lllllllllllllllll9 += max(llllllllllllllllllll9 - lllllllllllllllll9, 0.0) * ll0;
    }
    else if (lllllllllllllllllll9 == 8) 
    {
        lllllllllllllllll9 += min(llllllllllllllllllll9 - lllllllllllllllll9, 0.0) * ll0;
    }
    else if (lllllllllllllllllll9 == 9) 
    {
        float4 llllllllllllllllllllllll9 = lllllllllllllllll9 / max(llllllllllllllllllll9, 0.0001);
        lllllllllllllllll9 = lerp(lllllllllllllllll9, llllllllllllllllllllllll9, ll0);
    }
}
void DoToonShading(
#if _URP
    InputData inputData, 
    SurfaceData surface,
#else
#if _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
                 SurfaceOutputStandardSpecular o,
#elif _BDRFLAMBERT || _BDRF3 || _SIMPLELIT
                 SurfaceOutput o,
#else
                 SurfaceOutputStandard o,
#endif
    UnityGI gi,
#if !_PASSFORWARDADD
    UnityGIInput giInput,
#endif
#endif
    ShaderData d,
#if _URP
#if UNITY_VERSION >= 202120
    float3 lllllllllllllllllllllllllllllll9,
#endif
#endif
    inout float4 lllllllllllllllll9,
    int llllll10, float lllllll10,
    half llllllll10,
    half lllllllll10,
    float2 lllllllll1, float4 llllllllllllllllllllllllllll0,
    sampler2D llllllllllll10,
    half lllllllllllll10,
    half llllllllllllll10,
    half lllllllllllllll10, half llllllllllllllll10,
#ifdef USE_UNITY_TEXTURE_2D_TYPE
    UnityTexture2D llllllllllllllllll10,
#else
    sampler2D llllllllllllllllll10,
    float4 lllllllllllllllllll10,
#endif
    half llllllllllllllllllll10,
    half lllllllllllllllllllll10, float llllllllllllllllllllll10,
    half lllllllllllllllllllllll10, float4 llllllllllllllllllllllll10,
    float lllllllllllllllllllllllll10, float llllllllllllllllllllllllll10, float lllllllllllllllllllllllllll10, float4 llllllllllllllllllllllllllll10,
    float lllllllllllllllllllllllllllll10, float llllllllllllllllllllllllllllll10, float lllllllllllllllllllllllllllllll10, half l11, float4 ll11,
    half lll11,
    half llll11, half lllll11, float4 llllll11, float lllllll11, float llllllll11, float lllllllll11, half llllllllll11, half lllllllllll11,
    half llllllllllll11, half lllllllllllll11, float4 llllllllllllll11, float lllllllllllllll11, float llllllllllllllll11, float lllllllllllllllll11, half llllllllllllllllll11, half lllllllllllllllllll11,
    half llllllllllllllllllll11,
    UVSets uvSets,
    GeneralStylingData generalStylingData,
    half lllllllllllllllllllll11, half llllllllllllllllllllllllllllll7,
    half lllllllllllllllllllllll11,
    half llllllllllllllllllllllll11,
    float lllllllllllllllllllllllll11, float llllllllllllllllllllllllll11,
    half lllllllllllllllllllllllllll11,
    half llllllllllllllllllllllllllll11,
    PositionAndBlendingData positionAndBlendingDataShading, UVSpaceData uvSpaceDataShading, StylingData stylingDataShading, StylingRandomData stylingRandomDataShading,
    half lllllllllllllllllllllllllllll11,
    half llllllllllllllllllllllllllllll11,
    half lllllllllllllllllllllllllllllll11, float l12,
    PositionAndBlendingData positionAndBlendingDataCastShadows, UVSpaceData uvSpaceDataCastShadows, StylingData stylingDataCastShadows, StylingRandomData stylingRandomDataCastShadows,
    half ll12,
    half lll12, float llll12, float lllll12, half llllll12, half lllllll12,
    half llllllll12,
    PositionAndBlendingData positionAndBlendingDataSpecular, UVSpaceData uvSpaceDataSpecular, StylingData stylingDataSpecular, StylingRandomData stylingRandomDataSpecular,
    half lllllllll12,
    half llllllllll12, float lllllllllll12, float llllllllllll12, half lllllllllllll12,
    half llllllllllllll12,
    PositionAndBlendingData positionAndBlendingDataRim, UVSpaceData uvSpaceDataRim, StylingData stylingDataRim, StylingRandomData stylingRandomDataRim,
#ifdef USE_UNITY_TEXTURE_2D_TYPE
    UnityTexture2D lllllllllllllllll7, UnityTexture2D llllllllllllllllll7, 
#else
    sampler2D lllllllllllllllll7, sampler2D llllllllllllllllll7,
    float4 lllllllllllllllll12,
#endif
    float3 llllllllllllllllll12
)
{
    float4 llllllllllllllllllll12 = float4(0, 0, 0, 0);
#ifdef USE_UNITY_TEXTURE_2D_TYPE
    llllllllllllllllllll12 = llllllllllllllllll10.texelSize;
#else
    llllllllllllllllllll12 = lllllllllllllllllll10;
#endif
#if _URP
        AlphaDiscard(surface.alpha, 0.5);
#else
#endif
    float lllllllllllllllllllll12 = 0;
    float4 llllllllllllllllllllll12 = lllllllllllllllll9;
    int lllllllllllllllllllllll12 = llllll10;
#if _USE_OPTIMIZATION_DEFINES
    #if _ENABLE_TOON_SHADING
        lllllllllllllll10 = 1;
    #else
        lllllllllllllll10 = 0;
    #endif
        #if _SHADING_COLOR
            lllllllllllll10 = 0;
        #else
            lllllllllllll10 = 1;
        #endif 
    #if _ENABLE_STYLING
        llllllllllllllllllll11 = 1;
    #else
        llllllllllllllllllll11 = 0;
    #endif
    #if _ENABLE_SHADING_STYLING
        lllllllllllllllllllllll11 = 1;
    #else
        lllllllllllllllllllllll11 = 0;
    #endif
        #if _URP
            #ifdef _LIGHT_SOURCE
                    _LightSource = _LIGHT_SOURCE;
            #endif     
        #endif
        #if _ENABLE_CASTSHADOWS_STYLING
                lllllllllllllllllllllllllllll11 = 1;
        #else
                lllllllllllllllllllllllllllll11 = 0;
        #endif
        #ifdef _STYLING_CASTSHADOWS_SYNC_WITH_OTHER_STYLING
                llllllllllllllllllllllllllllll11 = _STYLING_CASTSHADOWS_SYNC_WITH_OTHER_STYLING;
        #endif  
        #if _SHADING_TERMINATORPOSITION
                lllllllllllllllllllllllll10 = lllllllllllllllllllllllll10;
        #else
                lllllllllllllllllllllllll10 = 0;
        #endif
        #if _SHADING_STYLING_TERMINATORPOSITION
                lllllllllllllllllllllllllll11 = lllllllllllllllllllllllllll11;
        #else
                lllllllllllllllllllllllllll11 = 0;
        #endif    
        #ifdef _SHADING_STYLING_UVSET
                _UVSet = _SHADING_STYLING_UVSET;
        #endif 
        #ifdef _CASTSHADOWS_STYLING_UVSET
                _CastShadowsUVSet = _CASTSHADOWS_STYLING_UVSET;
        #endif 
        #ifdef _SPECULAR_STYLING_UVSET
                _SpecularUVSet = _SPECULAR_STYLING_UVSET;
        #endif 
        #ifdef _RIM_STYLING_UVSET
                _RimUVSet = _RIM_STYLING_UVSET;
        #endif 
    #if _ENABLE_SPECULAR_STYLING
        ll12 = 1;
    #else
        ll12 = 0;
    #endif
    #if _ENABLE_SPECULAR
        llll11 = 1;
    #else
        llll11 = 0;
    #endif
        #if _SUM_LIGHTS_BEFORE_POSTERIZATION
            llllllll10 = 1;
        #else
            llllllll10 = 0;
        #endif
    #if _SHADING_USE_LIGHT_COLORS
        lllllllll10 = 1;
    #else
        lllllllll10 = 0;
    #endif
    #if _SPECULAR_USE_LIGHT_COLORS
        lllllllllll11 = 1;
    #else
        lllllllllll11 = 0;
    #endif
    #if _STYLING_SPECULAR_USE_LIGHT_COLORS
        lllllll12 = 1;
    #else
        lllllll12 = 0;
    #endif  
    #if _SHADING_STYLING_ENABLE_DASHES
            _StylingShadingEnableDashes = 1;
    #else
           _StylingShadingEnableDashes = 0;
    #endif
    #ifdef _SHADING_STYLING_DASHES_TYPE
            _StylingShadingDashesType = _SHADING_STYLING_DASHES_TYPE;
    #endif
    #if _CASTSHADOWS_STYLING_ENABLE_DASHES
            _StylingCastShadowsEnableDashes = 1;
    #else
           _StylingCastShadowsEnableDashes = 0;
    #endif
    #ifdef _CASTSHADOWS_STYLING_DASHES_TYPE
            _StylingCastShadowsDashesType = _CASTSHADOWS_STYLING_DASHES_TYPE;
    #endif
    #if _SPECULAR_STYLING_ENABLE_DASHES
            _StylingSpecularEnableDashes = 1;
    #else
            _StylingSpecularEnableDashes = 0;
    #endif
    #ifdef _SPECULAR_STYLING_DASHES_TYPE
            _StylingSpecularDashesType = _SPECULAR_STYLING_DASHES_TYPE;
    #endif
    #if _RIM_STYLING_ENABLE_DASHES
            _StylingRimEnableDashes = 1;
    #else
           _StylingRimEnableDashes = 0;
    #endif
    #ifdef _RIM_STYLING_DASHES_TYPE
            _StylingRimDashesType = _RIM_STYLING_DASHES_TYPE;
    #endif
#endif
    float3 llllllllllllllllllllllllll12;
    if (lll11 == 0)
    {
        llllllllllllllllllllllllll12 = llllllllllllllllll12;
    }
    else
    {
#if _URP 
        llllllllllllllllllllllllll12 = inputData.normalWS;
#else
        llllllllllllllllllllllllll12 = o.Normal;
#endif
    }
    float3 lllll2;
    if (llllllllll11 == 0)
    {
        lllll2 = llllllllllllllllll12;
    }
    else
    {
#if _URP 
        lllll2 = inputData.normalWS;
#else
        lllll2 = o.Normal;
#endif
    }
    float3 llllllllllllllllllllllllllll12;
    if (lllllllllllllllllllll11 == 0)
    {
        llllllllllllllllllllllllllll12 = llllllllllllllllll12;
    }
    else
    {
#if _URP 
        llllllllllllllllllllllllllll12 = inputData.normalWS;
#else
        llllllllllllllllllllllllllll12 = o.Normal;
#endif        
    }
    float3 lllllllllllllllllllllllllll1 = normalize(d.worldSpaceViewDir);
    float4 lll13 = 0;
    float llllllllllllllllllllllllllllll1 = -1;
    float lllll13 = -1;
    half3 llllll13 = 0;
    float llll4 = 0; 
    float llllllll13 = 0; 
    float lllllllllllllllllllllllllllllll1 = 0;
    half3 llllllllllllllllll3 = 0;
    float lllllllllll13 = 0;
    half3 llllllllllll13 = 0;
    float lllllllllllll13 = 0;
    ToonShadingData toonShadingData;
    toonShadingData.enableToonShading = lllllllllllllll10;
#if _URP
    toonShadingData.normalWS = inputData.normalWS;
#endif
    toonShadingData.normalWSNoMap = llllllllllllllllll12;
    toonShadingData.cellTransitionSmoothness = lllllll10;
    toonShadingData.numberOfCells = lllllllllllllllllllllll12;
    toonShadingData.specularEdgeSmoothness = llllllll11;
    toonShadingData.shadingAffectByNormalMap = lll11;
    toonShadingData.specularAffectedByNormalMap = llllllllll11;
#if _URP
    if ((lllllllllllll10 == 0 && lllllllllllllll10 == 1 && (lllllllllllllllllllllll10 == 1 || llll11 == 1 || lllllllllllllllllllllllllllll10 == 1)) || (llllllllllllllllllll11 == 1 && (lllllllllllllllllllllll11 == 1 || lllllllllllllllllllllllllllll11 == 1 || ll12 == 1)))
    {
        if (_LightSource != 1)
        {
            bool llllllllllllll13 = lllllllllllll10 == 0 && lllllllllllllll10 == 1;
            bool lllllllllllllll13 = llllllllllllllllllll11 == 1 && (lllllllllllllllllllllll11 == 1 || lllllllllllllllllllllllllllll11 == 1 || ll12 == 1);
            bool llllllllllllllll13 = lll11 == lllllllllllllllllllll11; 
            bool lllllllllllllllll13 = llllllllll11 == lllllllllllllllllllll11; 
            float llllllllllllllllll13 = 1;
            float lllllllllllllllllll13 = 1;
            Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
            MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
            float llllllllllllllllllll13 = max(mainLight.color.x, mainLight.color.y); 
            llllllllllllllllllll13 = max(llllllllllllllllllll13, mainLight.color.z);
            float3 llllllllllllllllllllllll12 = llllllllllllllllllllllllll12;
            float llllllllllllllllllllllllllll1 = lllllll11;
            float lllllllllllllllllllllllllllll1 = llllllll11;
            float llllllllllllllll3 = lllllllll11;
            float lllllllllllllllllllllllll13 = lllllllllll11;
            half llllllllllllllllllllllllll13 = llll11;
            half lllllllllllllllllllllllllll13 = lllllllllllllllllllllll10;
            if (!llllllllllllll13)
            {
                llllllllllllllllllllllll12 = llllllllllllllllllllllllllll12;
                lllll2 = llllllllllllllllllllllllllll12;
                llllllllllllllllllllllllllll1 = llll12;
                lllllllllllllllllllllllllllll1 = lllll12;
                llllllllllllllll3 = _StylingSpecularOpacity;
                lllllllllllllllllllllllll13 = lllllll12;
                llllllllllllllllllllllllll13 = ll12;
                lllllllllllllllllllllllllll13 = lllllllllllllllllllllll11;
                lllllllllllllllllllllllll10 = lllllllllllllllllllllllllll11;
            }
            else
            {
                if (lllllllllllllllllllllll10 == 0)
                {
                    llllllllllllllllllllllll12 = llllllllllllllllllllllllllll12;
                    lllllllllllllllllllllllllll13 = lllllllllllllllllllllll11;
                }
                if (llll11 == 0)
                {
                    lllll2 = llllllllllllllllllllllllllll12;
                    llllllllllllllllllllllllll13 = ll12;
                }
                else
                {
                    if (lllllllllllllll13 && ll12 == 1 && lll12 == 1)
                    {
                        llll12 = lllllll11;
                        lllll12 = llllllll11;
                    }
                }
            }
            float llllllllllllllllllllllllllll13 = 1;
            if (mainLight.color.r > 0.0 || mainLight.color.g > 0.0 || mainLight.color.b > 0.0)
            {
                llllllllllllllllllllllllllll13 = (mainLight.shadowAttenuation * mainLight.distanceAttenuation);
                half lllllllllllllllllllllllllllll13 = mainLight.distanceAttenuation * llllllllllllllllllll13;
                llllllllllllllllllllllllllllll1 = dot(mainLight.direction, llllllllllllllllllllllll12);
                if (lllllllllllllllllllllllll10 != 0.0)
                {
                    llllllllllllllllllllllllllllll1 = shiftLinear(llllllllllllllllllllllllllllll1, max(-0.9999, lllllllllllllllllllllllll10));
                }
                if (llllllllllllllllllllllllllllll1 > 0)
                {
                    llllllllllllllllllllllllllllll1 *= lllllllllllllllllllllllllllll13;
                }
                if (llllllllllllllllllllllllll13 || (!llllllllllllll13 && ll12))
                {
                    lllllllllllllllllllllllllllllll1 = CalculateSpecularMask(lllll2, mainLight.direction, lllllllllllllllllllllllllll1, llllllllllllllllllllllllllll1, lllllllllllllllllllllllllllll1, llllllllllllllllllllllllllllll1); 
                    lllllllllllllllllllllllllllllll1 *= llllllllllllllll3;
                    if ((llllllllllllll13 && lllllllllllllllllllllllllllll10) || (llllllllllllllllllll11 && lllllllllllllllllllllllllllll11))
                    {
                        lllllllllllllllllllllllllllllll1 = min(lllllllllllllllllllllllllllllll1, mainLight.shadowAttenuation);
                    }
                    if (lllllllllllllllllllllllll13 == 1)
                    {
                        llllllllllllllllll3 = lllllllllllllllllllllllllllllll1 * mainLight.color;
                    }
                }
                if (!llllllllllllll13)
                {
                    lllll13 = llllllllllllllllllllllllllllll1;
                    lllllllllll13 = lllllllllllllllllllllllllllllll1;
                    llllllllllll13 = llllllllllllllllll3;
                    lllllllllllllllllllllllllllllll1 = 0;
                    llllllllllllllllll3 = 0;
                }
                else
                {
                    if (lllllllllllllllllllllll10 == 0)
                    {
                        lllll13 = llllllllllllllllllllllllllllll1;
                    }
                    if (llll11 == 0)
                    {
                        lllllllllll13 = lllllllllllllllllllllllllllllll1;
                        llllllllllll13 = llllllllllllllllll3;
                        lllllllllllllllllllllllllllllll1 = 0;
                        llllllllllllllllll3 = 0;
                    }
                }
                if (lllllllllllllll13 && llllllllllllll13)
                {
                    if (llllllllllllllll13 && lllllllllllllllllllllllll11)
                    {
                        lllll13 = llllllllllllllllllllllllllllll1;
                    }
                    else
                    {
                        if (lllllllllllllllllllllllll11)
                        {
                            lllllllllllllllllllllllllll11 = lllllllllllllllllllllllll10;
                        }
                        lllll13 = dot(mainLight.direction, llllllllllllllllllllllllllll12);
                        if (lllllllllllllllllllllllllll11 != 0.0)
                        {
                            lllll13 = shiftLinear(lllll13, max(-0.9999, lllllllllllllllllllllllllll11));
                        }
                        if (lllll13 > 0)
                        {
                            lllll13 *= lllllllllllllllllllllllllllll13; 
                        }
                    }
                    if (ll12 == 1)
                    {
                        if (llllllllllllllll13 && lllllllllllllllll13 && lll12 == 1)
                        {
                            lllllllllll13 = lllllllllllllllllllllllllllllll1;
                            llllllllllll13 = llllllllllllllllll3;
                        }
                        else
                        {
                            lllllllllll13 = CalculateSpecularMask(llllllllllllllllllllllllllll12, mainLight.direction, lllllllllllllllllllllllllll1, llll12, lllll12, lllll13);
                            if (lllllllllllllllllllllllllllll10 || lllllllllllllllllllllllllllll11)
                            {
                                lllllllllll13 = min(lllllllllll13, mainLight.shadowAttenuation);
                            }
                            if (lllllll12 == 1)
                            {
                                llllllllllll13 = lllllllllll13 * mainLight.color;
                            }
                        }
                    }
                }
            {
                    llllllllllllllllll13 = llllllllllllllllllllllllllll13;
                }
            }
            else
            {
                llllllllllllllllll13 = 1;
                llllllllllllllllllllllllllll13 = 1;
                llllllllllllllllllllllllllllll1 = -1;
                lllll13 = -1;
            }
            float llllllllllllllllllllllllllllll13 = 0;
            float lllllllllllllllllllllllllllllll13 = 0;
            float l14 = 0;
            float ll14 = 0;
            float lll14 = 2;
            float llll14 = 2;
            float lllll14 = 0;
            float llllll14 = 1;
#if defined(_ADDITIONAL_LIGHTS)  
#if UNITY_VERSION >= 202200
        uint meshRenderingLayers = GetMeshRenderingLayer();
#else
            uint meshRenderingLayers = GetMeshRenderingLightLayer();
#endif
#if USE_CLUSTER_LIGHT_LOOP
        [loop]
            for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
            {
                Light addLight = GetAdditionalLight(lightIndex, inputData.positionWS, half4(1, 1, 1, 1));
#ifdef _LIGHT_LAYERS
            if (IsMatchingLightLayer(addLight.layerMask, meshRenderingLayers))
#endif
            {
                float llllllllllllllllllllll3 = max(addLight.color.x, addLight.color.y);
                llllllllllllllllllllll3 = max(llllllllllllllllllllll3, addLight.color.z);
                half llllllll14 = addLight.distanceAttenuation * llllllllllllllllllllll3;
                float lllllllll14 = smoothstep(0, 0.1 / (addLight.distanceAttenuation * llllllllllllllllllllll3), addLight.distanceAttenuation * llllllllllllllllllllll3);
                float llllllllll14 = smoothstep(0, 0.01, addLight.distanceAttenuation * llllllllllllllllllllll3);
                lllll14 += addLight.shadowAttenuation * llllllll14;
                float lllllllllll14 = dot(addLight.direction, llllllllllllllllllllllll12);
                if (lllllllllllllllllllllllll10 != 0)
                {
                    lllllllllll14 = shiftLinear(lllllllllll14, max(-0.9999, lllllllllllllllllllllllll10));
                }
                float llllllllllll14 = lerp(-1, lllllllllll14, lllllllll14);
        {
                    llllll14 = min(llllll14, lerp(1, addLight.shadowAttenuation, llllllllll14));
                }
                float lllllllllllll14 = saturate(llllllllllll14) * llllllll14; 
                l14 += lllllllllllll14;
                if (llllllllllllll13 || (lllllllllllllllllllllll11 == 1 && lllllllllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1))
                {
                    if (lllllllllllllllllllllllllllll10 == 1 || (!llllllllllllll13))
                    {
                        lllllllllllll14 *= addLight.shadowAttenuation;
                    }
                    llllllllllllllllllllllllllllll13 += lllllllllllll14;
                }
                if (llllllllllllll13)
                {
                    if (lllllllll10 == 1)
                    {
                        llllll13 += saturate(lllllllllllll14 * (addLight.color));
                    }
                }
                if (sign(llllllllllll14) == -1 && l14 == 0)
                {
                    float llllllllllllll14 = abs(llllllllllll14);
                    lll14 = min(lll14, llllllllllllll14);
                }
                float lllllllllllllll14 = 0;
                if (llll11 || (!llllllllllllll13 && ll12))
                {
                    lllllllllllllll14 = CalculateSpecularMask(lllll2, addLight.direction, lllllllllllllllllllllllllll1, llllllllllllllllllllllllllll1, lllllllllllllllllllllllllllll1, lllllllllll14);
                    lllllllllllllll14 *= llllllllllllllll3;
                    if (lllllllllllllllllllllllllllll10 || lllllllllllllllllllllllllllll11)
                    {
                        lllllllllllllll14 *= addLight.shadowAttenuation;
                    }
                    lllllllllllllllllllllllllllllll1 += lllllllllllllll14;
                    if (lllllllllllllllllllllllll13 == 1)
                    {
                        llllllllllllllllll3 += addLight.color * lllllllllllllll14;
                    }
                }
                if (lllllllllllllll13 && llllllllllllll13) 
                {
                    float llllllllllllllll14 = 0;
                    if (llllllllllllllll13 && (lllllllllllllllllllllllll11 || (lllllllllllllllllllllllll10 == lllllllllllllllllllllllllll11)))
                    {
                        ll14 = l14;
                        llll14 = lll14;
                        lllllllllllllllllllllllllllllll13 = llllllllllllllllllllllllllllll13;
                    }
                    else
                    {
                        llllllllllllllll14 = dot(addLight.direction, llllllllllllllllllllllllllll12);
                        if (lllllllllllllllllllllllll11)
                        {
                            lllllllllllllllllllllllllll11 = lllllllllllllllllllllllll10;
                        }
                        if (lllllllllllllllllllllllllll11 != 0)
                        {
                            llllllllllllllll14 = shiftLinear(llllllllllllllll14, max(-0.9999, lllllllllllllllllllllllllll11));
                        }
                        float lllllllllllllllll14 = lerp(-1, llllllllllllllll14, lllllllll14);
                        float llllllllllllllllll14 = saturate(lllllllllllllllll14) * llllllll14;
                        ll14 += llllllllllllllllll14;
                        if (lllllllllllllllllllllllllllll11 == 1 && lllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1)
                        {
                            llllllllllllllllll14 *= addLight.shadowAttenuation;
                            lllllllllllllllllllllllllllllll13 += llllllllllllllllll14;
                        }
                        if (sign(lllllllllllllllll14) == -1 && ll14 == 0)
                        {
                            float lllllllllllllllllll14 = abs(lllllllllllllllll14);
                            llll14 = min(llll14, lllllllllllllllllll14);
                        }
                    }
                    if (ll12 == 1)
                    {
                        float llllllllllllllllllll14 = 0;
                        if (llllllllllllllll13 && lllllllllllllllll13 && lll12 == 1)
                        {
                            lllllllllll13 = lllllllllllllllllllllllllllllll1;
                            llllllllllllllllllll14 = lllllllllllllll14;
                        }
                        else
                        {
                            llllllllllllllllllll14 = CalculateSpecularMask(lllll2, addLight.direction, lllllllllllllllllllllllllll1, llll12, lllll12, lllllllllll14);
                            llllllllllllllllllll14 = llllllllllllllllllll14;
                            if (lllllllllllllllllllllllllllll11)
                            {
                                llllllllllllllllllll14 *= addLight.shadowAttenuation;
                            }
                            lllllllllll13 += llllllllllllllllllll14;
                        }
                        if (lllllll12 == 1)
                        {
                            llllllllllll13 += addLight.color * llllllllllllllllllll14;
                        }
                    }
                }
                }
            }
#endif
            uint pixelLightCount = GetAdditionalLightsCount();
            LIGHT_LOOP_BEGIN(pixelLightCount)
            Light addLight = GetAdditionalLight(lightIndex, inputData.positionWS, half4(1, 1, 1, 1));
#ifdef _LIGHT_LAYERS
        if (IsMatchingLightLayer(addLight.layerMask, meshRenderingLayers))
#endif
        {  
                float llllllllllllllllllllll3 = max(addLight.color.x, addLight.color.y);
                llllllllllllllllllllll3 = max(llllllllllllllllllllll3, addLight.color.z);
                half llllllll14 = addLight.distanceAttenuation * llllllllllllllllllllll3;
                float lllllllll14 = smoothstep(0, 0.1 / (addLight.distanceAttenuation * llllllllllllllllllllll3), addLight.distanceAttenuation * llllllllllllllllllllll3);
                float llllllllll14 = smoothstep(0, 0.01, addLight.distanceAttenuation * llllllllllllllllllllll3);
                lllll14 += addLight.shadowAttenuation * llllllll14;
                float lllllllllll14 = dot(addLight.direction, llllllllllllllllllllllll12);
                if (lllllllllllllllllllllllll10 != 0)
                {
                    lllllllllll14 = shiftLinear(lllllllllll14, max(-0.9999, lllllllllllllllllllllllll10));
                }
                float llllllllllll14 = lerp(-1, lllllllllll14, lllllllll14);
            {
                    llllll14 = min(llllll14, lerp(1, addLight.shadowAttenuation, llllllllll14));
                }
                float lllllllllllll14 = saturate(llllllllllll14) * llllllll14; 
                l14 += lllllllllllll14;
                if (llllllllllllll13 || (lllllllllllllllllllllll11 == 1 && lllllllllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1))
                {
                    if (lllllllllllllllllllllllllllll10 == 1 || (!llllllllllllll13))
                    {
                        lllllllllllll14 *= addLight.shadowAttenuation;
                    }
                    llllllllllllllllllllllllllllll13 += lllllllllllll14;
                }
                if (llllllllllllll13)
                {
                    if (lllllllll10 == 1)
                    {
                        llllll13 += saturate(lllllllllllll14 * (addLight.color));
                    }
                }
                if (sign(llllllllllll14) == -1 && l14 == 0)
                {
                    float llllllllllllll14 = abs(llllllllllll14);
                    lll14 = min(lll14, llllllllllllll14);
                }
                float lllllllllllllll14 = 0;
                if (llll11 || (!llllllllllllll13 && ll12))
                {
                    lllllllllllllll14 = CalculateSpecularMask(lllll2, addLight.direction, lllllllllllllllllllllllllll1, llllllllllllllllllllllllllll1, lllllllllllllllllllllllllllll1, lllllllllll14);
                    lllllllllllllll14 *= llllllllllllllll3;
                    if (lllllllllllllllllllllllllllll10 || lllllllllllllllllllllllllllll11)
                    {
                        lllllllllllllll14 *= addLight.shadowAttenuation;
                    }
                    lllllllllllllllllllllllllllllll1 += lllllllllllllll14;
                    if (lllllllllllllllllllllllll13 == 1)
                    {
                        llllllllllllllllll3 += addLight.color * lllllllllllllll14;
                    }
                }
                if (lllllllllllllll13 && llllllllllllll13) 
                {
                    float llllllllllllllll14 = 0;
                    if (llllllllllllllll13 && (lllllllllllllllllllllllll11 || (lllllllllllllllllllllllll10 == lllllllllllllllllllllllllll11)))
                    {
                        ll14 = l14;
                        llll14 = lll14;
                        lllllllllllllllllllllllllllllll13 = llllllllllllllllllllllllllllll13;
                    }
                    else
                    {
                        llllllllllllllll14 = dot(addLight.direction, llllllllllllllllllllllllllll12);
                        if (lllllllllllllllllllllllll11)
                        {
                            lllllllllllllllllllllllllll11 = lllllllllllllllllllllllll10;
                        }
                        if (lllllllllllllllllllllllllll11 != 0)
                        {
                            llllllllllllllll14 = shiftLinear(llllllllllllllll14, max(-0.9999, lllllllllllllllllllllllllll11));
                        }
                        float lllllllllllllllll14 = lerp(-1, llllllllllllllll14, lllllllll14);
                        float llllllllllllllllll14 = saturate(lllllllllllllllll14) * llllllll14;
                        ll14 += llllllllllllllllll14;
                        if (lllllllllllllllllllllllllllll11 == 1 && lllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1)
                        {
                            llllllllllllllllll14 *= addLight.shadowAttenuation;
                            lllllllllllllllllllllllllllllll13 += llllllllllllllllll14;
                        }
                        if (sign(lllllllllllllllll14) == -1 && ll14 == 0)
                        {
                            float lllllllllllllllllll14 = abs(lllllllllllllllll14);
                            llll14 = min(llll14, lllllllllllllllllll14);
                        }
                    }
                    if (ll12 == 1)
                    {
                        float llllllllllllllllllll14 = 0;
                        if (llllllllllllllll13 && lllllllllllllllll13 && lll12 == 1)
                        {
                            lllllllllll13 = lllllllllllllllllllllllllllllll1;
                            llllllllllllllllllll14 = lllllllllllllll14;
                        }
                        else
                        {
                            llllllllllllllllllll14 = CalculateSpecularMask(lllll2, addLight.direction, lllllllllllllllllllllllllll1, llll12, lllll12, lllllllllll14);
                            llllllllllllllllllll14 = llllllllllllllllllll14;
                            if (lllllllllllllllllllllllllllll11)
                            {
                                llllllllllllllllllll14 *= addLight.shadowAttenuation;
                            }
                            lllllllllll13 += llllllllllllllllllll14;
                        }
                        if (lllllll12 == 1)
                        {
                            llllllllllll13 += addLight.color * llllllllllllllllllll14;
                        }
                    }
                }
            }
            LIGHT_LOOP_END
#endif
            if (lllllllllllllll10 == 1 && lllllllllllllllllllllll10 == 1 && lllllllll10 == 1)
            {
                float3 llll15 = saturate(saturate(llllllllllllllllllllllllllllll1) * (mainLight.color));
                if (lllllllllllllllllllllllllllll10 == 1)
                {
                    llll15 *= llllllllllllllllllllllllllll13;
                }
                llllll13 += saturate(llll15);
                llllll13 = saturate(llllll13);
                const float3 lllll15 = float3(0.2126, 0.7152, 0.0722);
                float llllll15 = dot(llllll13, lllll15); 
                float lllllll15 = Posterize(saturate(llllll15), toonShadingData); 
                const float llllllll15 = 1e-6; 
                float lllllllll15 = (llllll15 > llllllll15) ? (lllllll15 / llllll15) : 0.0;
                llllll13 = llllll13 * lllllllll15;
            }
            if (!llllllllllllll13)
            {
                ll14 = l14;
                lllllllllllllllllllllllllllllll13 = llllllllllllllllllllllllllllll13;
                llll14 = lll14;
                lllllllllll13 = lllllllllllllllllllllllllllllll1 + lllllllllll13; 
                llllllllllll13 = llllllllllllllllll3;
                lllllllllllllllllllllllllllllll1 = 0;
                llllllllllllllllll3 = 0;
            }
            float llllllllll15 = saturate(llllllllllllllllllllllllllllll1);
            float lllllllllll15 = saturate(llllllllllllllllllllllllllllll13);
            if (llllllllllllllll10 == 0)
            {
                if (llllllll10 == 0)
                {
                    llllllllll15 = Posterize(llllllllll15, toonShadingData);
                    lllllllllll15 = Posterize(lllllllllll15, toonShadingData);
                }
            }
            if (lllllllllllllll10 == 1 && lllllllllllllllllllllllllllll10 == 1 && (lllllllllllllllllllllll10 == 0 || (llllllllllll11 && llllllllllllllllll11 == 1)))
            {
                float llllllllllll15 = saturate(min(llllllllllllllllll13, llllll14));
                float lllllllllllll15 = llllllllllllllllllllllllllll13 * saturate(llllllllllllllllllllllllllllll1) + saturate(l14) * lllll14;
                float llllllllllllll15 = saturate((1 - llllllllllll15) * saturate(lllllllllllll15)) + llllllllllll15; 
                llll4 = llllllllllllll15;
            }
            if (llllllllllllllllllll11 == 1)
            {
                if (lllllllllllllllllllllllllllll11 == 1)
                {
                    if (llllllllllllllllllllllllllllll11 == 1)
                    {
                        llllllll13 = saturate(llllllllllllllllllllllllllll13 + lllll14);
                        if (lllll13 > 0)
                        {
                            lllll13 = saturate(lllll13);
                            lllll13 *= llllllllllllllllllllllllllll13;
                        }
                        if (ll14 > 0)
                        {
                            lllll13 = saturate(lllll13);
                            lllll13 += saturate(lllllllllllllllllllllllllllllll13);
                        }
                        else
                        {
                            if (llll14 > 0)
                            {
                                lllll13 = max(lllll13, -1 * llll14);
                            }
                        }
                    }
                    else
                    {
                        float llllllllllll15 = min(llllllllllllllllll13, llllll14);
                        float lllllllllllll15 = llllllllllllllllllllllllllll13 * saturate(lllll13) + saturate(ll14) * lllll14;
                        float llllllllllllll15 = ((1 - llllllllllll15) * (lllllllllllll15)) + llllllllllll15; 
                        llllllll13 = llllllllllllll15;
                    }
                }
                if (lllllllllllllllllllllllllllll11 == 0 || llllllllllllllllllllllllllllll11 != 1) 
                {
                    float llllllllllllllllll15 = lllll13;
                    lllll13 = saturate(lllll13) + saturate(ll14);
                    if (lllll13 == 0)
                    {
                        lllll13 = max(llllllllllllllllll15, -1 * llll14);
                    }
                }
            }
            if (llllllllllllllllllllllllllllll1 > 0)
            {
                llllllllllllllllllllllllllllll1 = saturate(llllllllll15);
                if (lllllllllllllllllllllllllllll10 == 1)
                {
                    llllllllllllllllllllllllllllll1 *= llllllllllllllllllllllllllll13;
                }
            }
            if (l14 > 0)
            {
                llllllllllllllllllllllllllllll1 = saturate(llllllllllllllllllllllllllllll1);
                llllllllllllllllllllllllllllll1 += saturate(lllllllllll15);
            }
            else
            {
                if (lll14 > 0)
                {
                    llllllllllllllllllllllllllllll1 = max(llllllllllllllllllllllllllllll1, -1 * lll14);
                }
            }
            if (llllllllllllllllllllllllllllll1 < 0)
            {
            }
            else
            {
                if (llllllllllllllll10 == 0 && llllllll10 == 1)
                {
                    llllllllllllllllllllllllllllll1 = Posterize(saturate(llllllllllllllllllllllllllllll1), toonShadingData);
                }
            }
        }
#if defined(LIGHTMAP_ON)  || defined(DYNAMICLIGHTMAP_ON) || defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2)
        if(_LightSource != 0) 
        {
            const float3 lllll15 = float3(0.2126, 0.7152, 0.0722);
            const float llllllll15 = 1e-6; 
            float3 lllllllllllllllllllll15 = (inputData.bakedGI);
            float llllll15 = dot(lllllllllllllllllllll15, lllll15); 
            llllllll13 = saturate(llllllll13+llllll15);
            if(_LightSource != 0 && lllllllllllllll10 == 1)
            {     
                if(lllllllllllll10 == 0) 
                {
                    if(llllllllllllllll10 == 0)
                    {    
                        float lllllllllllllllllllllll15 = llllll15;
                        if (lllllllllllllllllllllllll10 != 0.0) 
                        {
                            lllllllllllllllllllllll15 = shiftLinear(lllllllllllllllllllllll15, saturate(lllllllllllllllllllllllll10));
                        } 
                        lllllllllllll13 = lllllllllllllllllllllll15;
                    } 
                    else
                    {
                        if(llllll15 > 0) 
                        {
                            llllllllllllllllllllllllllllll1 = max(llllll15, llllllllllllllllllllllllllllll1);
                        }
                    }
                }    
            }
            if(_LightSource == 1)
            {
                lllll13 = 0;            
            }
            if(_LightSource != 0 && lllllllllllllllllllllll11 == 1)
            {                
                float llllllllllllllllllllllll15 = saturate(llllll15);
                if (lllllllllllllllllllllllllll11 != 0.0) 
                {
                    llllllllllllllllllllllll15 = shiftLinear(llllll15, saturate(lllllllllllllllllllllllllll11));
                }
                if(llllll15>0) 
                {
                    lllll13 = max(lllll13,saturate(llllllllllllllllllllllll15));
                }     
            }
        }
#endif
    }
#else 
    UnityLight lllllllllllllllllll12 = gi.light;
    llllllllllllllllllllllllllllll1 = dot(lllllllllllllllllll12.dir, llllllllllllllllllllllllll12);
    if (lllllllllllllllllllllllll10 != 0)
    {
        llllllllllllllllllllllllllllll1 = shiftLinear(llllllllllllllllllllllllllllll1, max(-0.9999, lllllllllllllllllllllllll10));
    }
    if (lllllllllllllllllllllllll11 == 0)
    {
        lllll13 = dot(lllllllllllllllllll12.dir, llllllllllllllllllllllllllll12);
        if (lllllllllllllllllllllllllll11 != 0)
        {
            lllll13 = shiftLinear(lllll13, max(-0.9999, lllllllllllllllllllllllllll11));
        }
    }
    else
    {
        lllll13 = llllllllllllllllllllllllllllll1;
    }
#if !_PASSFORWARDADD    
    if (llllllllllllllllllllllllllllll1 > 0)
    {
        llll4 = giInput.atten;
    }
    else
    {
        llll4 = 1;
    }
    if (lllllllllllllllllllllllllllll11 == 1 && lllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1)
    {
        lllll13 *= llll4;
    }
    llllllll13 = llll4;
#else    
    llll4 = 0;    
    llllllllllll11 = 0;    
    llllllllllllllllllll11 = 0;    
    lllllllll12 = 0;
    lllllllllllllllllllllll11 = 0;
    lllllllllllllllllllllllllllll11 = 0;
    stylingDataShading.color = 0;
    stylingDataSpecular.color = half4(gi.light.color,1);
#endif
#endif
    float llllllllllllllllllllllllllll15 = llll4;
    float lllllllllllllllllllllllllllll15 = 0;
    float4 llllllllllllllllllllllllllllll15 = 0;
    float3 lllllllllllllllllllllllllll3;
    if (lllllllllllllllllll11 == 0)
    {
        lllllllllllllllllllllllllll3 = llllllllllllllllll12;
    }
    else
    {
#if _URP 
        lllllllllllllllllllllllllll3 = inputData.normalWS;
#else
        lllllllllllllllllllllllllll3 = o.Normal;
#endif
    }
    float llllllllllll15 = 0;
    if (lllllllllllll10 == 0) 
    {
        llllllllllllllllllllllllllll15 = llll4;
        if (lllllllllllllll10 == 1)
        {
            float3 ll16 = llllllllllllllllllllllll10.rgb;
            if (lllllllllllllllllllllllllllll10 == 1
                        || (lllllllllllllllllllllll10 == 1 && llllllllllllllll10 == 0)
                        || (lllllllllllllllllllllll10 == 0 && llllllllllllllll10 == 0 && lllllllllllllllllllllllllllll10 == 1)
                        || _LightSource != 0
                        )
            {
                ll16 = lerp(llllllllllllllllllllllll10.rgb, llllllllllllllllllllll12.rgb, 1 - llllllllllllllllllllllll10.a);
            }
            if (llllllllllllllll10 == 0)
            {
                if (lllllllllllllllllllllll10 == 1)
                {
                    float lllllllllllllllllllllllllllll15 = saturate(llllllllllllllllllllllllllllll1);
#if _URP
                    float3 llll16 = 0;
                    if (_LightSource != 0)
                    {
                        float3 lllll16 = inputData.bakedGI;
                        float llllll16 = max(lllll16.r, max(lllll16.g, lllll16.b));
                        llll16 = lllll16 / max(llllll16, 1e-5); 
                    }
                    if (lllllllll10 == 1)
                    {
                        if (_LightSource != 0)
                        {
                            llllll13 *= lllllllllllllllllllllllllllll15;
                            llllll13 += llll16 * saturate(lllllllllllll13);
                        }
                        lllllllllllllllll9 *= float4(llllll13, 1);                        
                    }
                    if (_LightSource != 0)
                    {
                        float lllllll16 = PosterizeMulti(saturate(lllllllllllll13), toonShadingData, 1);
                        lllllllllllllllllllllllllllll15 = saturate(lllllllllllllllllllllllllllll15 + lllllll16);
                    }
#else
                    lllllllllllllllllllllllllllll15 = Posterize(lllllllllllllllllllllllllllll15, toonShadingData);
#endif
                    lllllllllllllllll9.xyz = lerp(ll16, lllllllllllllllll9.xyz, lllllllllllllllllllllllllllll15);
#if !_URP
                    if (lllllllllllllllllllllllllllll10 == 1)
                    {
                        lllllllllllllllll9 = float4(lerp(ll16, lllllllllllllllll9.rgb, saturate(llll4)), llllllllllllllllllllll12.a);
                    }
#endif
                }
            }
            else
            {
                float lllllllllllllllllllllllllllll16 = min(0.95, llllllllllllllllllllllllllllll1); 
                if (llllllllllllllllllll10 == 1 && lllllllllllllllllllllll10 == 0 && llllllllllllllllllllllllllllll1 < 0)
                {
                    lllllllllllllllllllllllllllll16 = 0;
                }
                lllllllllllllllllllllllllllll16 = (lllllllllllllllllllllllllllll16 + 1) / 2;
                float4 llllllllllllllllllllllllllllll16 = float4(0, 0, 0, 0);
                float lllllllllllllllllllllllllllllll16 = llllllllllllllllllll12.z;
                float l17 = lllllllllllllllllllllllllllll16 * (lllllllllllllllllllllllllllllll16 - 1);
                float2 ll17 = (l17 + 0.5) * llllllllllllllllllll12.xy;
                llllllllllllllllllllllllllllll16 = tex2D(llllllllllllllllll10, ll17);
                DoBlending(lllllllllllllllll9, llllllllllllllllllllll10, lllllllllllllllllllll10, llllllllllllllllllllllllllllll16);
            }
            if (lllllllllllllllllllllllllllll10 == 0 && (llllllllllllllllllll11 == 0 || lllllllllllllllllllllllllllll11 == 0))
            {
                llll4 = 1;
            }
            if (_LightSource == 0)
            {
                if (lllllllllllllllllllllll10 == 1 && llllllllllllllll10 == 0)
                {
                    if (llllllllllllllllllllllllllllll1 < 0.0 && saturate(lllllllllllll13) < 0.0001)
                    {
                        lllllllllllllllll9 = llllllllllllllllllllllllllll10;
                        lllllllllllllllllllllllllll10 = 1 - lllllllllllllllllllllllllll10;
                        float lllllll17 = lllllllllllllllllllllllllll10 * llllllllllllllllllllllllll10;
                        float llllllll17 = smoothstep(-lllllll17 + 0.01, -llllllllllllllllllllllllll10, llllllllllllllllllllllllllllll1);
                        float3 lllllllll17 = lerp(llllllllllllllllllllllllllll10.rgb, llllllllllllllllllllll12.rgb, 1 - llllllllllllllllllllllllllll10.a);
                        lllllllllllllllll9 = float4(lerp(ll16, lllllllll17, llllllll17), llllllllllllllllllllll12.a);
                    }
                }
                if (lllllllllllllllllllllll10 == 0 && llllllllllllllll10 == 0 && lllllllllllllllllllllllllllll10 == 1)
                {
                    lllllllllllllllll9 = float4(lerp(ll16, lllllllllllllllll9.rgb, saturate(llll4)), llllllllllllllllllllll12.a);
                }
            }
        }
        #if _URP
        if (_LightSource != 1) 
        #endif
        {
#if _ENABLE_SPECULAR || !_USE_OPTIMIZATION_DEFINES
            if (llll11 == 1)
            {
#if _URP
#else
                lllllllllllllllllllllllllllllll1 = CalculateSpecularMask(lllll2, lllllllllllllllllll12.dir, lllllllllllllllllllllllllll1, lllllll11, llllllll11, llllllllllllllllllllllllllllll1);
                lllllllllllllllllllllllllllllll1 *= lllllllll11;
                if (lllllllllllllllllllllllllllll10 == 1)
                {
                    lllllllllllllllllllllllllllllll1 *= llll4;
                }
#endif
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SPECULAR_BLENDING
            lllll11 = _SPECULAR_BLENDING;
#endif
#endif
                half4 llllllllll17;
                {
                    llllllllll17 = llllll11;
                }
                DoBlending(lllllllllllllllll9, lllllllllllllllllllllllllllllll1, lllll11, llllllllll17);
            }
#endif
        }
#if _URP
    lllllllllllllllll9 += half4(surface.emission, 0);
#else
        lllllllllllllllll9 += half4(o.Emission, 0);
#endif
    }
    else 
    {
        ToonShadingData toonShadingData;
        toonShadingData.enableToonShading = lllllllllllllll10;
#if _URP
        toonShadingData.normalWS = inputData.normalWS;
#endif
        toonShadingData.normalWSNoMap = llllllllllllllllll12;
        toonShadingData.cellTransitionSmoothness = lllllll10;
        toonShadingData.numberOfCells = lllllllllllllllllllllll12;
        toonShadingData.specularEdgeSmoothness = llllllll11;
        toonShadingData.shadingAffectByNormalMap = lll11;
        toonShadingData.specularAffectedByNormalMap = llllllllll11;
#if _USE_OPTIMIZATION_DEFINES
#if _ENABLE_TOON_SHADING 
                toonShadingData.enableToonShading = 1;
#else
                toonShadingData.enableToonShading = 0;
#endif
#endif
#if _SHADING_BLINNPHONG       
        if (llllllllllllll10 == 0) 
        {
#if _URP
#if UNITY_VERSION >= 202120
            lllllllllllllllll9 = UniversalFragmentBlinnPhong(inputData, surface.albedo, half4(surface.specular, surface.smoothness), surface.smoothness, surface.emission, surface.alpha,lllllllllllllllllllllllllllllll9, toonShadingData);
#else
            lllllllllllllllll9 = UniversalFragmentBlinnPhong(inputData, surface.albedo, half4(surface.specular, surface.smoothness), surface.smoothness, surface.emission, surface.alpha, toonShadingData);
#endif
#else
#endif
        }
#endif        
#if _SHADING_PBR
        if (llllllllllllll10 == 1) 
        {      
#if _URP
            lllllllllllllllll9 = UniversalFragmentPBR(inputData, surface, toonShadingData);
#else
#if !_PASSFORWARDADD
#if _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
#else
        LightingStandard_GI_Toon(o, giInput, gi, toonShadingData);
#if defined(_OVERRIDE_BAKEDGI)
            gi.indirect.diffuse = l.DiffuseGI;
            gi.indirect.specular = l.SpecularGI;
#endif
        lllllllllllllllll9 = LightingStandard_Toon (o, d.worldSpaceViewDir, gi, toonShadingData);
        lllllllllllllllll9 += half4(o.Emission, 0);
#endif     
#else
#if _USESPECULAR
#elif _BDRF3 || _SIMPLELIT
#else
                  lllllllllllllllll9 = LightingStandard_Toon (o, d.worldSpaceViewDir, gi, toonShadingData);
#endif
#endif
#endif
        }
#endif
    }
    float lllll4 = 0;
    if (lllllllllllllll10 == 1)
    {
#if _URP
        Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
        float llllllllllll17 = dot(mainLight.direction, lllllllllllllllllllllllllll3);
        float lllllllllllll17 = mainLight.shadowAttenuation;
#else
        float llllllllllllllllllllllllllllll1 = dot(lllllllllllllllllll12.dir, lllllllllllllllllllllllllll3);
#endif
#if _ENABLE_RIM || !_USE_OPTIMIZATION_DEFINES
#if !_USE_OPTIMIZATION_DEFINES
        if (llllllllllll11 == 1)
#endif
        {
#if _URP         
            lllll4 = CalculateRimMask(lllllllllllllllllllllllllll3, lllllllllllllllllllllllllll1, lllllllllllllll11, llllllllllllllll11, llllllllllll17, llllllllllllllllll11, lllllllllllllllllllllllllllll10, lllllllllllllllllllllll10, lllllllllllll17);
#else
            lllll4 = CalculateRimMask(lllllllllllllllllllllllllll3, lllllllllllllllllllllllllll1, lllllllllllllll11, llllllllllllllll11, llllllllllllllllllllllllllllll1, llllllllllllllllll11, lllllllllllllllllllllllllllll10, lllllllllllllllllllllll10, llll4);
#endif   
            lllll4 *= lllllllllllllllll11;
#if _USE_OPTIMIZATION_DEFINES
#ifdef _RIM_BLENDING
                        lllllllllllll11 = _RIM_BLENDING;
#endif
#endif   
            lllll4 = saturate(lllll4);
            DoBlending(lllllllllllllllll9, lllll4, lllllllllllll11, llllllllllllll11);
        }
#endif
    }
#if _ENABLE_STYLING || !_USE_OPTIMIZATION_DEFINES   
#if !_USE_OPTIMIZATION_DEFINES
    if (llllllllllllllllllll11 == 1)
#endif
    {
#ifdef _EMISSION 
#if _URP
        float3 lllllllllllllll17 = surface.emission;
#else
        float3 lllllllllllllll17 = o.Emission;
#endif
        float llllllllllllllllll17 = max(max(lllllllllllllll17.r, lllllllllllllll17.g), lllllllllllllll17.b);
#endif
#if !_URP
        if (ll12 == 1)
        {
            if (llll11 == 0 || lll12 == 0) 
            {
                float lllllllllllllllllll17 = saturate(llllllllllllllllllllllllllllll1);
                lllllllllll13 = CalculateSpecularMask(llllllllllllllllllllllllllll12, lllllllllllllllllll12.dir, lllllllllllllllllllllllllll1, llll12, lllll12, lllllllllllllllllll17);
                lllllllllll13 = saturate(lllllllllll13);
                lllllllllll13 *= llllllllllllllllllllllllllll15;
            }
            else
            {
                lllllllllll13 = saturate(lllllllllllllllllllllllllllllll1);
            }
        }
#endif
        if (llllll12 == 1)
        {
            lllll13 = 1 - lllll13 - lllllllllll13 * 10;
            lllll13 = 1 - lllll13;
            llllllllllllllllllllllllllll15 = 1 - ((1 - llllllllllllllllllllllllllll15) - lllllllllll13 * 10);
        }
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SHADING_STYLING_DRAWSPACE
        uvSpaceDataShading.drawSpace = _SHADING_STYLING_DRAWSPACE;
#endif
#ifdef _SHADING_STYLING_COORDINATESYSTEM
        uvSpaceDataShading.coordinateSystem = _SHADING_STYLING_COORDINATESYSTEM;
#endif
#endif
#if _URP
        float2 llllllllllllllllllll17 = ConvertToDrawSpace(inputData, lllllllll1, uvSpaceDataShading, llllllllllllllllllllllllllll0, uvSets);
#else
        float2 llllllllllllllllllll17 = ConvertToDrawSpace(d.worldSpacePosition, d.worldSpaceNormal, lllllllll1, uvSpaceDataShading, llllllllllllllllllllllllllll0, uvSets);
#endif
        float lllllllllllllllllllllll17 = stylingDataShading.density;
        float lllllllllllllllllll5 = stylingDataShading.size;
        float lllllllllllllllllllllllll17 = 1;
#if _ENABLE_SHADING_STYLING || !_USE_OPTIMIZATION_DEFINES   
#if !_USE_OPTIMIZATION_DEFINES
        if (lllllllllllllllllllllll11 != 0)
#endif        
        {
            float llllllllllllllllllllllllll17 = 0;
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SHADING_STYLING_BLENDING
                    positionAndBlendingDataShading.blending = _SHADING_STYLING_BLENDING;
#endif                   
#ifdef _SHADING_STYLE
                stylingDataShading.style = _SHADING_STYLE;
#endif
#if _SHADING_STYLING_RANDOMIZER
                stylingRandomDataShading.enableRandomizer = 1;
#else
                stylingRandomDataShading.enableRandomizer = 0;
#endif
#endif
            RequiredNoiseData requiredNoiseDataShading;
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SHADING_STYLING_RANDOMIZER_PERLIN
            requiredNoiseDataShading.perlinNoise = 1;
#else
            requiredNoiseDataShading.perlinNoise = 0;
#endif
#ifdef _SHADING_STYLING_RANDOMIZER_PERLIN_FLOORED
            requiredNoiseDataShading.perlinNoiseFloored = 1;
#else
            requiredNoiseDataShading.perlinNoiseFloored = 0;
#endif         
#ifdef _SHADING_STYLING_RANDOMIZER_WHITE
            requiredNoiseDataShading.whiteNoise = 1;
#else
            requiredNoiseDataShading.whiteNoise = 0;
#endif
#ifdef _SHADING_STYLING_RANDOMIZER_WHITE_FLOORED
            requiredNoiseDataShading.whiteNoiseFloored = 1;
#else
            requiredNoiseDataShading.whiteNoiseFloored = 0;
#endif            
#else            
            requiredNoiseDataShading.perlinNoise = 1;
            requiredNoiseDataShading.perlinNoiseFloored = 1;
            requiredNoiseDataShading.whiteNoise = 1;
            requiredNoiseDataShading.whiteNoiseFloored = 1;
#endif
            float lllllllllllllllllllllllllll17 = (lllll13);
            if (lllllllllllllllllllllllllllll11 == 1 && llllllllllllllllllllllllllllll11 == 1
#if _URP
                && _LightSource != 1
#endif                
                )
            {
                stylingDataShading.opacityFalloff *= llllllll13;
                stylingDataShading.sizeFalloff *= llllllll13;
            }
            if (positionAndBlendingDataShading.isInverted == 1)
            {
                lllllllllllllllllllllllllll17 = 1 - saturate(lllllllllllllllllllllllllll17);
            }
            if (stylingDataShading.style == 0) 
            {
                float lllllllllllllllllllllll17 = stylingDataShading.density;
                float lllllllllllllllllll5 = stylingDataShading.size;
                lllllllllllllllllll5 = stylingDataShading.size / 2;
                if (lllllllllllllllllllllllll11 == 0)
                {
                    lllllllllllllllllllllll12 = llllllllllllllllllllllllll11;
                }
                else
                {
                    lllllllllllllllllllllll12 = llllll10;
                }
#if _USE_OPTIMIZATION_DEFINES            
#ifdef _SHADING_STYLING_NUMBER_OF_CELLS_HATCHING
                        lllllllllllllllllllllll12 = _SHADING_STYLING_NUMBER_OF_CELLS_HATCHING;
#endif                            
#endif
                float llllllllllllllllllllllllllllll17 = (1. / lllllllllllllllllllllll12) * llllllllllllllllllllllllllll11;
                int lllllllllllllllllllllllllllllll17 = ceil((max(lllllllllllllllllllllllllll17 - llllllllllllllllllllllllllllll17, 0)) * lllllllllllllllllllllll12);
                lllllllllllllllllllllllllllllll17 = lllllllllllllllllllllll12 - lllllllllllllllllllllllllllllll17;
                float l18 = stylingDataShading.rotation;
                float ll18 = radians(l18);
                float lll18 = stylingDataShading.rotationBetweenCells;
                float llll18 = radians(lll18);
                float2 lllll18; 
                NoiseSampleData noiseSampleData; 
                lllllllllllllllllllllllll17 = 1;
                float lllllllllllllllll1 = 0;
    #if _USE_OPTIMIZATION_DEFINES            
                [unroll(lllllllllllllllllllllll12)]
    #else
                [unroll(15)]
#endif
                for (int i = 1; i <= lllllllllllllllllllllllllllllll17; i++)
                {
                    lllllllllllllllllll5 = stylingDataShading.size / 2;
                    float lllllll18 = i - 1;
                    float lll5 = ll18 + llll18 * lllllll18;
                    llllllllllllllllllll17 += lllllllllllllllll1; 
                    lllll18 = RotateUVRadians(llllllllllllllllllll17, lll5);
                    noiseSampleData = SampleNoiseData(lllll18, stylingDataShading, stylingRandomDataShading, requiredNoiseDataShading, lllllllllllllllll7, llllllllllllllllll7);
                    lllllllllllllllll1 += (float) stylingDataShading.density;
                    float lllllllll18 = lllll18.x;
                    float llllllllll18 = lllll18.y; 
                    float llll8 = max(stylingDataShading.dashDensity, 0.0001);
                    lllllllll18 *= stylingDataShading.density;
                    llllllllll18 *= llll8; 
                    float llllllllllll18 = floor(lllllllll18); 
                    float lllllllllllll18 = llllllllll18; 
                    float llllllllllllll18 = llllllllllllllllllllllllllllll7 ? fwidth(lllllllll18) : 0.0;
                    if (stylingRandomDataShading.enableRandomizer == 1)
                    {
                        lllllllll18 += noiseSampleData.perlinNoise * stylingRandomDataShading.noiseIntensity;
                        llllllllll18 += noiseSampleData.perlinNoise * stylingRandomDataShading.noiseIntensity; 
                        lllllllllllll18 = llllllllll18; 
                        llllllllllllll18 = llllllllllllllllllllllllllllll7 ? fwidth(lllllllll18) : 0.0;
                        float llllllll8 = 0;
                        if (stylingRandomDataShading.thicknessRandomMode == 0)
                        {
                            llllllll8 = noiseSampleData.whiteNoise;
                        }
                        else if (stylingRandomDataShading.thicknessRandomMode == 1) 
                        {
                            llllllll8 = noiseSampleData.perlinNoiseFloored;
                        }
                        else 
                        {
                            llllllll8 = ((noiseSampleData.perlinNoiseFloored) + noiseSampleData.whiteNoise) / 2;
                        }
                        float lllllllll8 = remap(0, 1, 0.0, lllllllllllllllllll5, llllllll8 * stylingRandomDataShading.thicknesshRandomIntensity);
                        lllllllllllllllllll5 -= lllllllll8;
                        float llllllllll8 = 0;
                        if (stylingRandomDataShading.spacingRandomMode == 0)
                        {
                            llllllllll8 = noiseSampleData.whiteNoise;
                        }
                        else if (stylingRandomDataShading.spacingRandomMode == 1) 
                        {
                            llllllllll8 = noiseSampleData.perlinNoiseFloored;
                        }
                        else 
                        {
                            llllllllll8 = ((noiseSampleData.perlinNoiseFloored) + noiseSampleData.whiteNoise) / 2;
                        }
                        float lllllllllll8 = lllllllllllllllllll5;
                        if (stylingDataShading.dashEnabled == 1 && _StylingShadingDashesType == 1)
                        {
                            lllllllllll8 = CalculateHatchingDashSafeSpacingHalfWidth(
                                lllllllllllllllllll5,
                                stylingDataShading.hardness,
                                llllllllllllll18,
                                llllllllllllllllllllllllllllll7
                            );
                        }
                        float llllllllllll8 = remap(0, 1, -0.5 + lllllllllll8, 0.5 - lllllllllll8, llllllllll8);
                        lllllllll18 += llllllllllll8 * stylingRandomDataShading.spacingRandomIntensity * saturate(1 - stylingRandomDataShading.noiseIntensity); 
                    }
                    lllllllll18 = abs(frac(lllllllll18) - 0.5);
                    float llllllllllllllllllll18 = (float) (lllllllllllllllllllllll12 - i) / lllllllllllllllllllllll12;
                    float lllllllllllllllllllll18 = remap(0, 1, 0, llllllllllllllllllllllllllllll17, llllllllllllllllllllllllllll11);
                    float lllllllllll5;
                    float lllllllllllllll8;
                    float llllllllllllllllllllllll18 = 0;
                    if (stylingRandomDataShading.enableRandomizer == 1)
                    {
                        float llllllllllllll8 = 0;
                        if (stylingRandomDataShading.lengthRandomMode == 0)
                        {
                            llllllllllllll8 = noiseSampleData.whiteNoise * saturate(1 - stylingRandomDataShading.noiseIntensity);
                        }
                        else if (stylingRandomDataShading.lengthRandomMode == 1)
                        {
                            llllllllllllll8 = noiseSampleData.perlinNoiseFloored; 
                        }
                        else
                        {
                            llllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + (noiseSampleData.whiteNoise * saturate(1 - stylingRandomDataShading.noiseIntensity))) / 2); 
                        }
                        lllllllllllllll8 = llllllllllllll8 * stylingRandomDataShading.lengthRandomIntensity;
                        llllllllllllllllllllllll18 = remap(0, 1, 0, llllllllllllllllllll18 + lllllllllllllllllllll18, lllllllllllllll8);
                    }
                    lllllllllll5 = remap(0, llllllllllllllllllll18 + lllllllllllllllllllll18 - llllllllllllllllllllllll18, 0, 1, lllllllllllllllllllllllllll17);
                    if (i == lllllllllllllllllllllll12 && sign(lllllllllllllllllllllllllll17) == 1)
                    {
                        float llllllllllllllllllllllll18 = 0;
                        if (stylingRandomDataShading.enableRandomizer == 1)
                        {
                            llllllllllllllllllllllll18 = remap(0, 1, 0, 1 - llllllllllllllllllllllllllllll17, lllllllllllllll8);
                        }
                        lllllllllll5 = remap(0, llllllllllllllllllllllllllllll17, 1 - llllllllllllllllllllllllllllll17 + llllllllllllllllllllllll18, 1 + llllllllllllllllllllllll18, lllllllllllllllllllllllllll17);
                    }
                    if (i == lllllllllllllllllllllll12 && sign(lllllllllllllllllllllllllll17) == -1)
                    {
                        float lllllllllllllllllllllllllll18 = (float) 1. / lllllllllllllllllllllll12;
                        lllllllllllllllllllll18 = remap(0, 1, 0, lllllllllllllllllllllllllll18, llllllllllllllllllllllllllll11);
                        float llllllllllllllllllllllll18 = 0;
                        if (stylingRandomDataShading.enableRandomizer == 1)
                        {
                            llllllllllllllllllllllll18 = remap(0, 1, 0, 1 - lllllllllllllllllllll18, lllllllllllllll8);
                        }
                        lllllllllll5 = remap(0, -1, 1 - lllllllllllllllllllll18 + llllllllllllllllllllllll18, 0, lllllllllllllllllllllllllll17);
                    }
                    float llllllllllllllll8 = smoothstep(1 - stylingDataShading.sizeFalloff, 1, lllllllllll5);
                    if (llllllllllllllllllllllllllll15 <= 0 && lllllllllllllllllllllllllll17 > 0)
                    {
                    }
                    llllllllllllllll8 = max(lllllllllllllllllll5 - llllllllllllllll8, 0);
                    float llllllllllllllllllllllllllllll18;
                    if (stylingRandomDataShading.enableRandomizer == 1)
                    {
                        float llllllllllllllllll8 = 0;
                        if (stylingRandomDataShading.hardnessRandomMode == 0) 
                        {
                            llllllllllllllllll8 = noiseSampleData.whiteNoise;
                        }
                        else if (stylingRandomDataShading.hardnessRandomMode == 1) 
                        {
                            llllllllllllllllll8 = noiseSampleData.perlinNoiseFloored * 5;
                        }
                        else
                        {
                            llllllllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + noiseSampleData.whiteNoise) / 2) * 5;
                        }
                        llllllllllllllllllllllllllllll18 = remap(0, 1, 0, llllllllllllllll8, min(saturate(stylingDataShading.hardness - llllllllllllllllll8 * stylingRandomDataShading.hardnessRandomIntensity), stylingDataShading.hardness));
                    }
                    else
                    {
                        llllllllllllllllllllllllllllll18 = remap(0, 1, 0, llllllllllllllll8, stylingDataShading.hardness);
                    }
                    float l19 = (llllllllllllllll8 > 0.0001) ? saturate(llllllllllllllllllllllllllllll18 / max(llllllllllllllll8, 0.0001)) : stylingDataShading.hardness;
                    float llllllllllll6 = lllllllll18;
                    float lllllllllll6 = CalculateHatching1DMaskFromDistance(
                            llllllllllll6,
                            llllllllllllllll8,
                            l19,
                            lllllllllllllllllll5,
                            stylingDataShading.size,
                            llllllllllllll18,
                            llllllllllllllllllllllllllllll7
                        );
                    lllllllll18 = lllllllllll6;
                    if (stylingDataShading.dashEnabled == 1 && i == 1)
                    {
                        float llllllllllllllllllll8 = CalculateHatchingDashContinuity(
                            stylingDataShading.dashTransitionPosition,
                            stylingDataShading.dashTransitionSoftness,
                            lllllllllll5
                        );
                        float lllllllllllllllllllll8 = saturate(stylingDataShading.dashLength) * 0.5;
                        float lllllllllllllll6 = lerp(lllllllllllllllllllll8, 0.5, llllllllllllllllllll8);
                        llllllllll18 += llllllllllll18 * saturate(stylingDataShading.dashOffset);
                        float lllllll19 = llllllllllllllllllllllllllllll7 ? fwidth(lllllllllllll18) : 0.0;
                        float lllllllllllll6 = abs(frac(llllllllll18) - 0.5);
                        lllllllll18 = ApplyHatchingDashMode(
                                lllllllllll6,
                                llllllllllll6,
                                lllllllllllll6,
                                llllllllllllllll8,
                                lllllllllllllll6,
                                l19,
                                llllllllllllll18,
                                lllllll19,
                                stylingDataShading.dashType,
                                stylingDataShading.dashRoundness,
                                llllllllllllllllllllllllllllll7
                            );
                    }
                    if (stylingRandomDataShading.enableRandomizer == 1)
                    {
                        float lllllllllllllllllllllllll8;
                        if (stylingRandomDataShading.opacityRandomMode == 0) 
                        {
                            lllllllllllllllllllllllll8 = noiseSampleData.whiteNoise;
                        }
                        else if (stylingRandomDataShading.opacityRandomMode == 1) 
                        {
                            lllllllllllllllllllllllll8 = noiseSampleData.perlinNoiseFloored * 5;
                        }
                        else 
                        {
                            lllllllllllllllllllllllll8 = ((noiseSampleData.perlinNoiseFloored + noiseSampleData.whiteNoise) / 2) * 5;
                        }
                        lllllllll18 = saturate(lllllllll18 - (lllllllllllllllllllllllll8 * stylingRandomDataShading.opacityRandomIntensity));
                    }
                    float llllllllllllllllllllllllll8 = smoothstep(saturate(min(1 - stylingDataShading.opacityFalloff, 1)), 1, lllllllllll5);
                    lllllllll18 *= 1 - llllllllllllllllllllllllll8;
                    lllllllll18 = 1 - lllllllll18;
                    lllllllllllllllllllllllll17 = min(lllllllll18, lllllllllllllllllllllllll17);
                }
                lllllllllllllllllllllllll17 = 1 - lllllllllllllllllllllllll17;
                lllllllllllllllllllllllll17 *= stylingDataShading.opacity;
                lllllllllllllllllllllllll17 = 1 - lllllllllllllllllllllllll17;
                llllllllllllllllllllllllll17 = lllllllllllllllllllllllll17;
            }
            else if (stylingDataShading.style == 1) 
            {
                float2 llllllllllllllllllllllllllllll8 = llllllllllllllllllll17;
                float2 lllllllllllllllllllllllllllllll4 = RotateUV(llllllllllllllllllllllllllllll8, stylingDataShading.rotation);
                NoiseSampleData noiseSampleData = SampleNoiseData(lllllllllllllllllllllllllllllll4, stylingDataShading, stylingRandomDataShading, requiredNoiseDataShading, lllllllllllllllll7, llllllllllllllllll7);
                if (false)
                {
                } 
                float lllllllllllll19 = 1 - lllllllllllllllllllllllllll17;
                float llllllllllllll9 = Halftones(lllllllllllll19, lllllllllllllllllllllllllllllll4, stylingDataShading, stylingRandomDataShading, noiseSampleData);
                llllllllllllllllllllllllll17 = llllllllllllll9;
            }
            if (false)
            {
            }
#ifdef _EMISSION
            llllllllllllllllllllllllll17 = 1 - llllllllllllllllllllllllll17;
            llllllllllllllllllllllllll17 = saturate(llllllllllllllllllllllllll17 - llllllllllllllllll17);
            llllllllllllllllllllllllll17 = 1 - llllllllllllllllllllllllll17;
#endif
#if _USE_OPTIMIZATION_DEFINES
#if _ENABLE_STYLING_DISTANCEFADE
                     generalStylingData.enableDistanceFade = 1;
#else
                    generalStylingData.enableDistanceFade = 0;
#endif
#endif
            if (generalStylingData.enableDistanceFade == 1)
            {
                float lllllllllllllll19 = lllllllllllllllllllllllllll17;
                if (stylingDataShading.style == 0)
                {
                    int lllllllllllllllllllllll12;
                    if (lllllllllllllllllllllllll11 == 0)
                    {
                        lllllllllllllllllllllll12 = llllllllllllllllllllllllll11;
                    }
                    else
                    {
                        lllllllllllllllllllllll12 = llllll10;
                    }
                    float llllllllllllllllllllllllllllll17 = (1. / lllllllllllllllllllllll12) * llllllllllllllllllllllllllll11;
                    float lllllllllllllllllllll18 = remap(0, 1, 0, llllllllllllllllllllllllllllll17, llllllllllllllllllllllllllll11);
                    lllllllllllllll19 -= -1 + ((lllllllllllllllllllllll12 - 1.) / lllllllllllllllllllllll12) + lllllllllllllllllllll18;
                }
                float lllllllllllllllllll19 = distance(_WorldSpaceCameraPos, d.worldSpacePosition);
                float llllllllllllllllllll19 = max(lllllllllllllll19, 1 - stylingDataShading.opacityFalloff);
                llllllllllllllllllll19 = remap(1 - stylingDataShading.opacityFalloff, 1, 0, 1, llllllllllllllllllll19);
                float lllllllllllllllllllll19 = max(lllllllllllllll19, 1 - stylingDataShading.sizeFalloff);
                lllllllllllllllllllll19 = remap(1 - stylingDataShading.sizeFalloff, 1, 0, 1, lllllllllllllllllllll19);
                float llllllllllllllllllllll19 = lerp(0.0, 1, saturate(1 - stylingDataShading.size)); 
                if (generalStylingData.adjustDistanceFadeValue == 1)
                {
                    llllllllllllllllllllll19 = generalStylingData.distanceFadeValue;
                }
                lllllllllllllllllllll19 = max(llllllllllllllllllllll19, lllllllllllllllllllll19 * 2);
                llllllllllllllllllll19 = max(llllllllllllllllllllll19, llllllllllllllllllll19);
                float lllllllllllllllllllllll19 = max(lllllllllllllllllllll19, llllllllllllllllllll19);
                lllllllllllllllllllllll19 = saturate(lllllllllllllllllllllll19);
                llllllllllllllllllllllllll17 = lerp(llllllllllllllllllllllllll17, lllllllllllllllllllllll19, saturate(((lllllllllllllllllll19 - generalStylingData.distanceFadeStartDistance) / generalStylingData.distanceFadeFalloff)));
            }
            if (positionAndBlendingDataShading.isInverted == 1)
            {
                llllllllllllllllllllllllll17 = 1 - llllllllllllllllllllllllll17;
            }
            DoBlending(lllllllllllllllll9, 1 - llllllllllllllllllllllllll17, positionAndBlendingDataShading.blending, stylingDataShading.color);
            if (false)
            {
            }
            if (false)
            {
            }
        }
#endif
    #if _URP
        if (_LightSource != 1) 
    #endif
        {
#if (_ENABLE_CASTSHADOWS_STYLING && _STYLING_CASTSHADOWS_SYNC_WITH_OTHER_STYLING != 1) || !_USE_OPTIMIZATION_DEFINES   
#if !_USE_OPTIMIZATION_DEFINES
            if (lllllllllllllllllllllllllllll11 && llllllllllllllllllllllllllllll11 != 1)   
#endif
            {
#if _USE_OPTIMIZATION_DEFINES
#ifdef _CASTSHADOWS_STYLING_BLENDING
                positionAndBlendingDataCastShadows.blending = _CASTSHADOWS_STYLING_BLENDING;
#endif
#ifdef _CASTSHADOWS_STYLING_DRAWSPACE
                uvSpaceDataCastShadows.drawSpace = _CASTSHADOWS_STYLING_DRAWSPACE;
#endif
#ifdef _CASTSHADOWS_STYLING_COORDINATESYSTEM
                uvSpaceDataCastShadows.coordinateSystem = _CASTSHADOWS_STYLING_COORDINATESYSTEM;
#endif            
#ifdef _CASTSHADOWS_STYLE
                stylingDataCastShadows.style = _CASTSHADOWS_STYLE;
#endif
#if _CASTSHADOWS_STYLING_RANDOMIZER
                stylingRandomDataCastShadows.enableRandomizer = 1;
#else
                stylingRandomDataCastShadows.enableRandomizer = 0;
#endif
#endif
                RequiredNoiseData requiredNoiseDataCastShadows;
#if _USE_OPTIMIZATION_DEFINES
#ifdef _CASTSHADOWS_STYLING_RANDOMIZER_PERLIN
                requiredNoiseDataCastShadows.perlinNoise = 1;
#else
                requiredNoiseDataCastShadows.perlinNoise = 0;
#endif
#ifdef _CASTSHADOWS_STYLING_RANDOMIZER_PERLIN_FLOORED
                requiredNoiseDataCastShadows.perlinNoiseFloored = 1;
#else
                requiredNoiseDataCastShadows.perlinNoiseFloored = 0;
#endif         
#ifdef _CASTSHADOWS_STYLING_RANDOMIZER_WHITE
                requiredNoiseDataCastShadows.whiteNoise = 1;
#else
                requiredNoiseDataCastShadows.whiteNoise = 0;
#endif
#ifdef _CASTSHADOWS_STYLING_RANDOMIZER_WHITE_FLOORED
                requiredNoiseDataCastShadows.whiteNoiseFloored = 1;
#else
                requiredNoiseDataCastShadows.whiteNoiseFloored = 0;
#endif            
#else            
                requiredNoiseDataCastShadows.perlinNoise = 1;
                requiredNoiseDataCastShadows.perlinNoiseFloored = 1;
                requiredNoiseDataCastShadows.whiteNoise = 1;
                requiredNoiseDataCastShadows.whiteNoiseFloored = 1;
#endif
#if _URP
            float2 llllllllllllllllllllllll19 = ConvertToDrawSpace(inputData, lllllllll1, uvSpaceDataCastShadows, llllllllllllllllllllllllllll0, uvSets);
#else
                float2 llllllllllllllllllllllll19 = ConvertToDrawSpace(d.worldSpacePosition, d.worldSpaceNormal, lllllllll1, uvSpaceDataCastShadows, llllllllllllllllllllllllllll0, uvSets);
#endif
#ifdef _EMISSION
            llllllll13 = 1 - llllllll13;
            llllllll13 = saturate(llllllll13 - llllllllllllllllll17);
            llllllll13 = 1 - llllllll13;
#endif
                llllllllllllllllllllllllllll15 = llllllll13;
                float llllllllllllllllllllllllll17 = 0;
                if (stylingDataCastShadows.style == 0) 
                {
                    float lllllllllllllllllllllllllll19 = stylingDataCastShadows.rotation;
                    float llllllllllllllllllllllllllll19 = radians(lllllllllllllllllllllllllll19);
                    float lllllllllllllllllllllllllllll19 = stylingDataCastShadows.rotationBetweenCells;
                    float llllllllllllllllllllllllllllll19 = radians(lllllllllllllllllllllllllllll19);
                    float lllllllllllllllllllllllllllllll19 = l12;
                    lllllllllllllllllllllllllllllll19 = min(lllllllllllllllllllllllllllllll19, 0.99);
                    float l20 = 1;
                    float lllllllllllllllllllllll12 = lllllllllllllllllllllllllllllll11;
            #if _USE_OPTIMIZATION_DEFINES            
                #ifdef _CASTSHADOWS_STYLING_NUMBER_OF_CELLS_HATCHING
                        lllllllllllllllllllllll12 = _CASTSHADOWS_STYLING_NUMBER_OF_CELLS_HATCHING;
                #endif                           
                [unroll(lllllllllllllllllllllll12)]
            #else
                [unroll(15)]
#endif
                    for (int j = 1; j <= lllllllllllllllllllllll12; j++)
                    {
                        llllllll13 = min(j / lllllllllllllllllllllll12, llllllllllllllllllllllllllll15);
                        if (lllllllllllllllllllllll12 != 1)
                        {
                            float lllllllllllllllllllllllllll9 = 0;
                            if (lllllllllllllllllllllll12 <= 1)
                            {
                                lllllllllllllllllllllllllll9 = 0.0;
                            }
                            else
                            {
                                float llll20 = (float) j - 1;
                                float lllll20 = (float) (lllllllllllllllllllllll12 - 1);
                                float llllll20 = llll20 / lllll20;
                                lllllllllllllllllllllllllll9 = lerp(1.0, llllll20, lllllllllllllllllllllllllllllll19);
                            }
                            float lllllll20 = min(lllllllllllllllllllllllllll9, llllllllllllllllllllllllllll15); 
                            lllllll20 = remap(0, lllllllllllllllllllllllllll9, 0, 1, llllllllllllllllllllllllllll15);
                            llllllll13 = lllllll20;
                            llllllll13 = max(llllllll13, llllllllllllllllllllllllllll15);
                        }
                        else
                        {
                            llllllll13 = llllllllllllllllllllllllllll15;
                        }
                        float lllllll18 = j - 1;
                        float lll5 = llllllllllllllllllllllllllll19 + llllllllllllllllllllllllllllll19 * lllllll18;
                        float2 lllll18 = RotateUVRadians(llllllllllllllllllllllll19, lll5);
                        lllll18.x += (j - 1) / (float) lllllllllllllllllllllll12 * stylingDataCastShadows.density; 
                        NoiseSampleData noiseSampleData = SampleNoiseData(lllll18, stylingDataCastShadows, stylingRandomDataCastShadows, requiredNoiseDataCastShadows, lllllllllllllllll7, llllllllllllllllll7);
                        float lllllllllll20 = Hatching(1 - llllllll13, lllll18, stylingDataCastShadows, stylingRandomDataCastShadows, noiseSampleData, llllllllllllllllllllllllllllll7);
                        lllllllllll20 = 1 - lllllllllll20;
                    {
                            l20 = min(lllllllllll20, l20);
                        }
                    }
                    llllllllllllllllllllllllll17 = l20;
                }
                else if (stylingDataCastShadows.style == 1) 
                {
                    float2 lllllllllllllllllllllllllllllll4 = RotateUV(llllllllllllllllllllllll19, stylingDataCastShadows.rotation);
                    NoiseSampleData noiseSampleData = SampleNoiseData(lllllllllllllllllllllllllllllll4, stylingDataCastShadows, stylingRandomDataCastShadows, requiredNoiseDataCastShadows, lllllllllllllllll7, llllllllllllllllll7);
                    float llllllllllllll9 = Halftones(1 - llllllll13, lllllllllllllllllllllllllllllll4, stylingDataCastShadows, stylingRandomDataCastShadows, noiseSampleData);
                    llllllllllllllllllllllllll17 = llllllllllllll9;
                }
                DoBlending(lllllllllllllllll9, 1 - llllllllllllllllllllllllll17, positionAndBlendingDataCastShadows.blending, stylingDataCastShadows.color);
            }
#endif        
        }
        #if _URP
        if (_LightSource != 1) 
        #endif
        {
#if _ENABLE_SPECULAR_STYLING || !_USE_OPTIMIZATION_DEFINES   
#if !_USE_OPTIMIZATION_DEFINES
            if (ll12)   
#endif
            {
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SPECULAR_STYLING_BLENDING
                positionAndBlendingDataSpecular.blending = _SPECULAR_STYLING_BLENDING;
#endif
#ifdef _SPECULAR_STYLING_DRAWSPACE
                uvSpaceDataSpecular.drawSpace = _SPECULAR_STYLING_DRAWSPACE;
#endif
#ifdef _SPECULAR_STYLING_COORDINATESYSTEM
                uvSpaceDataSpecular.coordinateSystem = _SPECULAR_STYLING_COORDINATESYSTEM;
#endif            
#ifdef _SPECULAR_STYLE
                stylingDataSpecular.style = _SPECULAR_STYLE;
#endif
#if _SPECULAR_STYLING_RANDOMIZER
                stylingRandomDataSpecular.enableRandomizer = 1;
#else
                stylingRandomDataSpecular.enableRandomizer = 0;
#endif
#endif
                RequiredNoiseData requiredNoiseDataSpecular;
#if _USE_OPTIMIZATION_DEFINES            
#ifdef _SPECULAR_STYLING_RANDOMIZER_PERLIN
                requiredNoiseDataSpecular.perlinNoise = 1;
#else
                requiredNoiseDataSpecular.perlinNoise = 0;
#endif
#ifdef _SPECULAR_STYLING_RANDOMIZER_PERLIN_FLOORED
                requiredNoiseDataSpecular.perlinNoiseFloored = 1;
#else
                requiredNoiseDataSpecular.perlinNoiseFloored = 0;
#endif         
#ifdef _SPECULAR_STYLING_RANDOMIZER_WHITE
                requiredNoiseDataSpecular.whiteNoise = 1;
#else
                requiredNoiseDataSpecular.whiteNoise = 0;
#endif
#ifdef _SPECULAR_STYLING_RANDOMIZER_WHITE_FLOORED
                requiredNoiseDataSpecular.whiteNoiseFloored = 1;
#else
                requiredNoiseDataSpecular.whiteNoiseFloored = 0;
#endif      
#else            
                requiredNoiseDataSpecular.perlinNoise = 1;
                requiredNoiseDataSpecular.perlinNoiseFloored = 1;
                requiredNoiseDataSpecular.whiteNoise = 1;
                requiredNoiseDataSpecular.whiteNoiseFloored = 1;
#endif
#if _URP
                float2 llllllllllllll20 = ConvertToDrawSpace(inputData, lllllllll1, uvSpaceDataSpecular, llllllllllllllllllllllllllll0, uvSets);
#else
                float2 llllllllllllll20 = ConvertToDrawSpace(d.worldSpacePosition, d.worldSpaceNormal, lllllllll1, uvSpaceDataSpecular, llllllllllllllllllllllllllll0, uvSets);
#endif
                float2 lllllllllllllllllllllllllllllll4 = RotateUV(llllllllllllll20, stylingDataSpecular.rotation);
                llllllllllllll20 = lllllllllllllllllllllllllllllll4;
                NoiseSampleData noiseSampleData = SampleNoiseData(llllllllllllll20, stylingDataSpecular, stylingRandomDataSpecular, requiredNoiseDataSpecular, lllllllllllllllll7, llllllllllllllllll7);
#if _USE_OPTIMIZATION_DEFINES 
#ifdef _SPECULAR_STYLE
            stylingDataSpecular.style = _SPECULAR_STYLE;
#endif
#endif
                float llllllllllllllllllllllllll17 = 0;
                if (stylingDataSpecular.style == 0) 
                {
                    llllllllllllllllllllllllll17 = Hatching(lllllllllll13, llllllllllllll20, stylingDataSpecular, stylingRandomDataSpecular, noiseSampleData, llllllllllllllllllllllllllllll7);
                    llllllllllllllllllllllllll17 = 1 - llllllllllllllllllllllllll17;
                }
                else if (stylingDataSpecular.style == 1) 
                {
                    float llllllllllllll9 = Halftones(lllllllllll13, llllllllllllll20, stylingDataSpecular, stylingRandomDataSpecular, noiseSampleData);
                    llllllllllllllllllllllllll17 = llllllllllllll9;
                }
#if _USE_OPTIMIZATION_DEFINES
#ifdef _SPECULAR_STYLING_BLENDING
                     positionAndBlendingDataSpecular.blending = _SPECULAR_STYLING_BLENDING;
#endif
#endif
                half4 llllllllll17;
                if (lllllll12 == 1)
                {
                    llllllllll17 = half4(llllllllllll13, 1);
                }
                else
                {
                    llllllllll17 = stylingDataSpecular.color;
                }
                DoBlending(lllllllllllllllll9, 1 - llllllllllllllllllllllllll17, positionAndBlendingDataSpecular.blending, llllllllll17);
            }
#endif
        }
#if _ENABLE_RIM_STYLING || !_USE_OPTIMIZATION_DEFINES   
#if !_USE_OPTIMIZATION_DEFINES
        if (lllllllll12)
#endif
        {
#if _USE_OPTIMIZATION_DEFINES
#ifdef _RIM_STYLING_BLENDING
                    positionAndBlendingDataRim.blending = _RIM_STYLING_BLENDING;
#endif
#ifdef _RIM_STYLING_DRAWSPACE
                uvSpaceDataRim.drawSpace = _RIM_STYLING_DRAWSPACE;
#endif
#ifdef _RIM_STYLING_COORDINATESYSTEM
                uvSpaceDataRim.coordinateSystem = _RIM_STYLING_COORDINATESYSTEM;
#endif        
#ifdef _RIM_STYLE
                stylingDataRim.style = _RIM_STYLE;
#endif
#if _RIM_STYLING_RANDOMIZER
                stylingRandomDataRim.enableRandomizer = 1;
#else
                stylingRandomDataRim.enableRandomizer = 0;
#endif
#endif
            RequiredNoiseData requiredNoiseDataRim;
#if _USE_OPTIMIZATION_DEFINES
#ifdef _RIM_STYLING_RANDOMIZER_PERLIN
                requiredNoiseDataRim.perlinNoise = 1;
#else
                requiredNoiseDataRim.perlinNoise = 0;
#endif
#ifdef _RIM_STYLING_RANDOMIZER_PERLIN_FLOORED
                requiredNoiseDataRim.perlinNoiseFloored = 1;
#else
                requiredNoiseDataRim.perlinNoiseFloored = 0;
#endif         
#ifdef _RIM_STYLING_RANDOMIZER_WHITE
                requiredNoiseDataRim.whiteNoise = 1;
#else
                requiredNoiseDataRim.whiteNoise = 0;
#endif
#ifdef _RIM_STYLING_RANDOMIZER_WHITE_FLOORED
                requiredNoiseDataRim.whiteNoiseFloored = 1;
#else
                requiredNoiseDataRim.whiteNoiseFloored = 0;
#endif      
#else            
            requiredNoiseDataRim.perlinNoise = 1;
            requiredNoiseDataRim.perlinNoiseFloored = 1;
            requiredNoiseDataRim.whiteNoise = 1;
            requiredNoiseDataRim.whiteNoiseFloored = 1;
#endif
#if _URP
            float2 lllllllllllllllllllll20 = ConvertToDrawSpace(inputData, lllllllll1, uvSpaceDataRim, llllllllllllllllllllllllllll0, uvSets);
#else
            float2 lllllllllllllllllllll20 = ConvertToDrawSpace(d.worldSpacePosition, d.worldSpaceNormal, lllllllll1, uvSpaceDataRim, llllllllllllllllllllllllllll0, uvSets);
#endif
            float2 lllllllllllllllllllllllllllllll4 = RotateUV(lllllllllllllllllllll20, stylingDataRim.rotation);
            NoiseSampleData noiseSampleData = SampleNoiseData(lllllllllllllllllllllllllllllll4, stylingDataRim, stylingRandomDataRim, requiredNoiseDataRim, lllllllllllllllll7, llllllllllllllllll7);
            if (llllllllllll11 == 0 || llllllllll12 == 0) 
            {
#if _URP
                Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
                float llllllllllll17 = dot(mainLight.direction, lllllllllllllllllllllllllll3);
                float lllllllllllll17 = mainLight.shadowAttenuation;
                lllll4 = CalculateRimMask(llllllllllllllllllllllllllll12, lllllllllllllllllllllllllll1, lllllllllll12, llllllllllll12, llllllllllll17, lllllllllllll12, lllllllllllllllllllllllllllll10, lllllllllllllllllllllll10, lllllllllllll17);
#else
                lllll4 = CalculateRimMask(llllllllllllllllllllllllllll12, lllllllllllllllllllllllllll1, lllllllllll12, llllllllllll12, llllllllllllllllllllllllllllll1, lllllllllllll12, lllllllllllllllllllllllllllll10, lllllllllllllllllllllll10, llll4);
#endif
            }
            lllll4 = saturate(lllll4 - lllllllllllllllllllllllllllllll1 * 10);
            float llllllllllllllllllllllllll17 = 0;
            if (stylingDataRim.style == 0) 
            {
                llllllllllllllllllllllllll17 = Hatching(lllll4, lllllllllllllllllllllllllllllll4, stylingDataRim, stylingRandomDataRim, noiseSampleData, llllllllllllllllllllllllllllll7);
                llllllllllllllllllllllllll17 = 1 - llllllllllllllllllllllllll17;
            }
            else if (stylingDataRim.style == 1) 
            {
                float llllllllllllll9 = Halftones(lllll4, lllllllllllllllllllllllllllllll4, stylingDataRim, stylingRandomDataRim, noiseSampleData);
                llllllllllllllllllllllllll17 = llllllllllllll9;
            }
            DoBlending(lllllllllllllllll9, 1 - llllllllllllllllllllllllll17, positionAndBlendingDataRim.blending, stylingDataRim.color);
        }
#endif
    }
#endif


}

    
    
    
    
    
    
    
    
    
    
    
    
    
    

        


void AddTheToonShader(inout float4 albedo,

#if _URP
    InputData inputData, 
    SurfaceData surface,
#else
#if _USESPECULAR || _USESPECULARWORKFLOW || _SPECULARFROMMETALLIC
                 SurfaceOutputStandardSpecular o,
#elif _BDRFLAMBERT || _BDRF3 || _SIMPLELIT

                 SurfaceOutput o,
#else
                 SurfaceOutputStandard o,
#endif

    UnityGI gi,
#if !_PASSFORWARDADD
    UnityGIInput giInput,
#endif
#endif

 ShaderData d
#if _URP
#if UNITY_VERSION >= 202120
, float3 normalTS
#endif
#endif

)
{
    
    float2 uv = d.texcoord0.xy;
    
    UVSets uvSets;
    uvSets.uv0 = d.texcoord0.xy;
    uvSets.uv1 = d.texcoord1.xy;
    uvSets.uv2 = d.texcoord2.xy;
    uvSets.uv3 = d.texcoord3.xy;
    
    
    
        
    

    
    float3 pureNormal = d.worldSpaceNormal;

    float4 screenUV = d.extraV2F0;

    

    
    UVSpaceData uvSpaceDataShading;
    uvSpaceDataShading.drawSpace = _DrawSpace;
    uvSpaceDataShading.uvSet = _UVSet;
    uvSpaceDataShading.coordinateSystem = _CoordinateSystem;
    uvSpaceDataShading.polarCenterMode = _PolarCenterMode;
    uvSpaceDataShading.polarCenter = _PolarCenter;
    uvSpaceDataShading.sSCameraDistanceScaled = _SSCameraDistanceScaled;
    uvSpaceDataShading.anchorSSToObjectsOrigin = _AnchorSSToObjectsOrigin;
    
     
    
    UVSpaceData uvSpaceDataCastShadows;
    uvSpaceDataCastShadows.drawSpace = _CastShadowsDrawSpace;
    uvSpaceDataCastShadows.uvSet = _CastShadowsUVSet;
    uvSpaceDataCastShadows.coordinateSystem = _CastShadowsCoordinateSystem;
    uvSpaceDataCastShadows.polarCenterMode = _CastShadowsPolarCenterMode;
    uvSpaceDataCastShadows.polarCenter = _CastShadowsPolarCenter;
    uvSpaceDataCastShadows.sSCameraDistanceScaled = _CastShadowsSSCameraDistanceScaled;
    uvSpaceDataCastShadows.anchorSSToObjectsOrigin = _CastShadowsAnchorSSToObjectsOrigin;
    
    UVSpaceData uvSpaceDataSpecular;
    uvSpaceDataSpecular.drawSpace = _SpecularDrawSpace;
    uvSpaceDataSpecular.uvSet = _SpecularUVSet;
    uvSpaceDataSpecular.coordinateSystem = _SpecularCoordinateSystem;
    uvSpaceDataSpecular.polarCenterMode = _SpecularPolarCenterMode;
    uvSpaceDataSpecular.polarCenter = _SpecularPolarCenter;
    uvSpaceDataSpecular.sSCameraDistanceScaled = _SpecularSSCameraDistanceScaled;
    uvSpaceDataSpecular.anchorSSToObjectsOrigin = _SpecularAnchorSSToObjectsOrigin;
    
    UVSpaceData uvSpaceDataRim;
    uvSpaceDataRim.drawSpace = _RimDrawSpace;
    uvSpaceDataRim.uvSet = _RimUVSet;
    uvSpaceDataRim.coordinateSystem = _RimCoordinateSystem;
    uvSpaceDataRim.polarCenterMode = _RimPolarCenterMode;
    uvSpaceDataRim.polarCenter = _RimPolarCenter;
    uvSpaceDataRim.sSCameraDistanceScaled = _RimSSCameraDistanceScaled;
    uvSpaceDataRim.anchorSSToObjectsOrigin = _RimAnchorSSToObjectsOrigin;

    GeneralStylingData generalStylingData;
    generalStylingData.enableDistanceFade = _EnableStylingDistanceFade;
    generalStylingData.distanceFadeStartDistance = _StylingDFStartingDistance;
    generalStylingData.distanceFadeFalloff = _StylingDFFalloff;
    generalStylingData.adjustDistanceFadeValue = _StylingAdjustDistanceFadeValue;
    generalStylingData.distanceFadeValue = _StylingDistanceFadeValue;
    StylingData stylingDataShading;
    stylingDataShading.style = _ShadingStyle;
    stylingDataShading.type = 0;
    stylingDataShading.color = _StylingColor;
    stylingDataShading.rotation = _StylingShadingInitialDirection;
    stylingDataShading.rotationBetweenCells = _StylingShadingRotationBetweenCells;
    stylingDataShading.density = _StylingShadingDensity;
    stylingDataShading.offset = _StylingShadingHalftonesOffset;
    stylingDataShading.size = _StylingShadingThickness;
    stylingDataShading.sizeControl = _StylingShadingThicknessControl;
    stylingDataShading.sizeFalloff = _StylingShadingThicknessFalloff;
    stylingDataShading.roundness = _StylingShadingHalftonesRoundness;
    stylingDataShading.roundnessFalloff = _StylingShadingHalftonesRoundnessFalloff;
    stylingDataShading.hardness = _StylingShadingHardness;
    stylingDataShading.opacity = _StylingShadingOpacity;
    stylingDataShading.opacityFalloff = _StylingShadingOpacityFalloff;
    
    
    
    stylingDataShading.dashEnabled = _StylingShadingEnableDashes;
    stylingDataShading.dashType = _StylingShadingDashesType;
    stylingDataShading.dashLength = _StylingShadingDashesSize;
    stylingDataShading.dashDensity = _StylingShadingDashesUseHatchingDensity == 1 ? _StylingShadingDensity : _StylingShadingDashesDensity;
    stylingDataShading.dashTransitionPosition = _StylingShadingDashesTransitionPosition;
    stylingDataShading.dashTransitionSoftness = _StylingShadingDashesTransitionSoftness;
    stylingDataShading.dashRoundness = _StylingShadingDashesRoundness;
    stylingDataShading.dashOffset = _StylingShadingDashesOffset;
    

    StylingData stylingDataSpecular;
    stylingDataSpecular.style = _SpecularStyle;
    stylingDataSpecular.type = 1;
    stylingDataSpecular.color = _StylingSpecularColor;
    stylingDataSpecular.rotation = _StylingSpecularRotation;
    stylingDataSpecular.density = _StylingSpecularDensity;
    stylingDataSpecular.offset = _StylingSpecularHalftonesOffset;
    stylingDataSpecular.size = _StylingSpecularThickness;
    stylingDataSpecular.sizeControl = _StylingSpecularThicknessControl;
    stylingDataSpecular.sizeFalloff = _StylingSpecularThicknessFalloff;
    stylingDataSpecular.roundness = _StylingSpecularHalftonesRoundness;
    stylingDataSpecular.roundnessFalloff = _StylingSpecularHalftonesRoundnessFalloff;
    stylingDataSpecular.hardness = _StylingSpecularHardness;
    stylingDataSpecular.opacity = _StylingSpecularOpacity;
    stylingDataSpecular.opacityFalloff = _StylingSpecularOpacityFalloff;

    
    stylingDataSpecular.dashEnabled = _StylingSpecularEnableDashes;
    stylingDataSpecular.dashType = _StylingSpecularDashesType;
    stylingDataSpecular.dashLength = _StylingSpecularDashesSize;
    stylingDataSpecular.dashDensity = _StylingSpecularDashesUseHatchingDensity == 1 ? _StylingSpecularDensity : _StylingSpecularDashesDensity;
    stylingDataSpecular.dashTransitionPosition = _StylingSpecularDashesTransitionPosition;
    stylingDataSpecular.dashTransitionSoftness = _StylingSpecularDashesTransitionSoftness;
    stylingDataSpecular.dashRoundness = _StylingSpecularDashesRoundness;
    stylingDataSpecular.dashOffset = _StylingSpecularDashesOffset;
    

    
    StylingData stylingDataCastShadows;
    
    stylingDataCastShadows.style = _CastShadowsStyle;
    stylingDataCastShadows.type = 1;
    stylingDataCastShadows.color = _StylingCastShadowsColor;
    stylingDataCastShadows.rotation = _StylingCastShadowsInitialDirection;
    stylingDataCastShadows.rotationBetweenCells = _StylingCastShadowsRotationBetweenCells;
    stylingDataCastShadows.density = _StylingCastShadowsDensity;
    stylingDataCastShadows.offset = _StylingCastShadowsHalftonesOffset;
    stylingDataCastShadows.size = _StylingCastShadowsThickness;
    stylingDataCastShadows.sizeControl = _StylingCastShadowsThicknessControl;
    stylingDataCastShadows.sizeFalloff = _StylingCastShadowsThicknessFalloff;
    stylingDataCastShadows.roundness = _StylingCastShadowsHalftonesRoundness;
    stylingDataCastShadows.roundnessFalloff = _StylingCastShadowsHalftonesRoundnessFalloff;
    stylingDataCastShadows.hardness = _StylingCastShadowsHardness;
    stylingDataCastShadows.opacity = _StylingCastShadowsOpacity;
    stylingDataCastShadows.opacityFalloff = _StylingCastShadowsOpacityFalloff;

    
    stylingDataCastShadows.dashEnabled = _StylingCastShadowsEnableDashes;
    stylingDataCastShadows.dashType = _StylingCastShadowsDashesType;
    stylingDataCastShadows.dashLength = _StylingCastShadowsDashesSize;
    stylingDataCastShadows.dashDensity = _StylingCastShadowsDashesUseHatchingDensity == 1 ? _StylingCastShadowsDensity : _StylingCastShadowsDashesDensity;
    stylingDataCastShadows.dashTransitionPosition = _StylingCastShadowsDashesTransitionPosition;
    stylingDataCastShadows.dashTransitionSoftness = _StylingCastShadowsDashesTransitionSoftness;
    stylingDataCastShadows.dashRoundness = _StylingCastShadowsDashesRoundness;
    stylingDataCastShadows.dashOffset = _StylingCastShadowsDashesOffset;
    

    StylingData stylingDataRim;
    stylingDataRim.style = _RimStyle;
    stylingDataRim.type = 1;
    stylingDataRim.color = _StylingRimColor;
    stylingDataRim.rotation = _StylingRimRotation;
    stylingDataRim.density = _StylingRimDensity;
    stylingDataRim.offset = _StylingRimHalftonesOffset;
    stylingDataRim.size = _StylingRimThickness;
    stylingDataRim.sizeControl = _StylingRimThicknessControl;
    stylingDataRim.sizeFalloff = _StylingRimThicknessFalloff;
    stylingDataRim.roundness = _StylingRimHalftonesRoundness;
    stylingDataRim.roundnessFalloff = _StylingRimHalftonesRoundnessFalloff;
    stylingDataRim.hardness = _StylingRimHardness;
    stylingDataRim.opacity = _StylingRimOpacity;
    stylingDataRim.opacityFalloff = _StylingRimOpacityFalloff;

    
    stylingDataRim.dashEnabled = _StylingRimEnableDashes;
    stylingDataRim.dashType = _StylingRimDashesType;
    stylingDataRim.dashLength = _StylingRimDashesSize;
    stylingDataRim.dashDensity = _StylingRimDashesUseHatchingDensity == 1 ? _StylingRimDensity : _StylingRimDashesDensity;
    stylingDataRim.dashTransitionPosition = _StylingRimDashesTransitionPosition;
    stylingDataRim.dashTransitionSoftness = _StylingRimDashesTransitionSoftness;
    stylingDataRim.dashRoundness = _StylingRimDashesRoundness;
    stylingDataRim.dashOffset = _StylingRimDashesOffset;
    

    
 
    
    PositionAndBlendingData positionAndBlendingDataShading;
            
    positionAndBlendingDataShading.blending = _StylingShadingBlending;
    positionAndBlendingDataShading.isInverted = _StylingShadingIsInverted;

    PositionAndBlendingData positionAndBlendingDataSpecular;
            
    positionAndBlendingDataSpecular.blending = _StylingSpecularBlending;
    positionAndBlendingDataSpecular.isInverted = _StylingSpecularIsInverted;
    
    PositionAndBlendingData positionAndBlendingDataCastShadows;
    positionAndBlendingDataCastShadows.blending = _StylingCastShadowsBlending;
    positionAndBlendingDataCastShadows.isInverted = _StylingCastShadowsIsInverted;
    
    PositionAndBlendingData positionAndBlendingDataRim;
            
    positionAndBlendingDataRim.blending = _StylingRimBlending;
    positionAndBlendingDataRim.isInverted = _StylingRimIsInverted;



    StylingRandomData stylingRandomDataShading;
    stylingRandomDataShading.enableRandomizer = _EnableShadingRandomizer;
    stylingRandomDataShading.perlinNoiseSize = _ShadingNoise1Size;
    stylingRandomDataShading.perlinNoiseSeed = _ShadingNoise1Seed;
    stylingRandomDataShading.whiteNoiseSeed = _ShadingNoise2Seed;
    stylingRandomDataShading.noiseIntensity = _NoiseIntensity;
    stylingRandomDataShading.spacingRandomMode = _SpacingRandomMode;
    stylingRandomDataShading.spacingRandomIntensity = _SpacingRandomIntensity;
    stylingRandomDataShading.opacityRandomMode = _OpacityRandomMode;
    stylingRandomDataShading.opacityRandomIntensity = _OpacityRandomIntensity;
    stylingRandomDataShading.lengthRandomMode = _LengthRandomMode;
    stylingRandomDataShading.lengthRandomIntensity = _LengthRandomIntensity;
    stylingRandomDataShading.hardnessRandomMode = _HardnessRandomMode;
    stylingRandomDataShading.hardnessRandomIntensity = _HardnessRandomIntensity;
    stylingRandomDataShading.thicknessRandomMode = _ThicknessRandomMode;
    stylingRandomDataShading.thicknesshRandomIntensity = _ThicknesshRandomIntensity;
    
    
    
    StylingRandomData stylingRandomDataSpecular;
    stylingRandomDataSpecular.enableRandomizer = _EnableSpecularRandomizer;
    stylingRandomDataSpecular.perlinNoiseSize = _SpecularNoise1Size;
    stylingRandomDataSpecular.perlinNoiseSeed = _SpecularNoise1Seed;
    stylingRandomDataSpecular.whiteNoiseSeed = _SpecularNoise2Seed;
    stylingRandomDataSpecular.noiseIntensity = _SpecularNoiseIntensity;
    stylingRandomDataSpecular.spacingRandomMode = _SpecularSpacingRandomMode;
    stylingRandomDataSpecular.spacingRandomIntensity = _SpecularSpacingRandomIntensity;
    stylingRandomDataSpecular.opacityRandomMode = _SpecularOpacityRandomMode;
    stylingRandomDataSpecular.opacityRandomIntensity = _SpecularOpacityRandomIntensity;
    stylingRandomDataSpecular.lengthRandomMode = _SpecularLengthRandomMode;
    stylingRandomDataSpecular.lengthRandomIntensity = _SpecularLengthRandomIntensity;
    stylingRandomDataSpecular.hardnessRandomMode = _SpecularHardnessRandomMode;
    stylingRandomDataSpecular.hardnessRandomIntensity = _SpecularHardnessRandomIntensity;
    stylingRandomDataSpecular.thicknessRandomMode = _SpecularThicknessRandomMode;
    stylingRandomDataSpecular.thicknesshRandomIntensity = _SpecularThicknesshRandomIntensity;
    
    StylingRandomData stylingRandomDataCastShadows;
    stylingRandomDataCastShadows.enableRandomizer = _EnableCastShadowsRandomizer;
    stylingRandomDataCastShadows.perlinNoiseSize = _CastShadowsNoise1Size;
    stylingRandomDataCastShadows.perlinNoiseSeed = _CastShadowsNoise1Seed;
    stylingRandomDataCastShadows.whiteNoiseSeed = _CastShadowsNoise2Seed;
    stylingRandomDataCastShadows.noiseIntensity = _CastShadowsNoiseIntensity;
    stylingRandomDataCastShadows.spacingRandomMode = _CastShadowsSpacingRandomMode;
    stylingRandomDataCastShadows.spacingRandomIntensity = _CastShadowsSpacingRandomIntensity;
    stylingRandomDataCastShadows.opacityRandomMode = _CastShadowsOpacityRandomMode;
    stylingRandomDataCastShadows.opacityRandomIntensity = _CastShadowsOpacityRandomIntensity;
    stylingRandomDataCastShadows.lengthRandomMode = _CastShadowsLengthRandomMode;
    stylingRandomDataCastShadows.lengthRandomIntensity = _CastShadowsLengthRandomIntensity;
    stylingRandomDataCastShadows.hardnessRandomMode = _CastShadowsHardnessRandomMode;
    stylingRandomDataCastShadows.hardnessRandomIntensity = _CastShadowsHardnessRandomIntensity;
    stylingRandomDataCastShadows.thicknessRandomMode = _CastShadowsThicknessRandomMode;
    stylingRandomDataCastShadows.thicknesshRandomIntensity = _CastShadowsThicknesshRandomIntensity;

    StylingRandomData stylingRandomDataRim;
    stylingRandomDataRim.enableRandomizer = _EnableRimRandomizer;
    stylingRandomDataRim.perlinNoiseSize = _RimNoise1Size;
    stylingRandomDataRim.perlinNoiseSeed = _RimNoise1Seed;
    stylingRandomDataRim.whiteNoiseSeed = _RimNoise2Seed;
    stylingRandomDataRim.noiseIntensity = _RimNoiseIntensity;
    stylingRandomDataRim.spacingRandomMode = _RimSpacingRandomMode;
    stylingRandomDataRim.spacingRandomIntensity = _RimSpacingRandomIntensity;
    stylingRandomDataRim.opacityRandomMode = _RimOpacityRandomMode;
    stylingRandomDataRim.opacityRandomIntensity = _RimOpacityRandomIntensity;
    stylingRandomDataRim.lengthRandomMode = _RimLengthRandomMode;
    stylingRandomDataRim.lengthRandomIntensity = _RimLengthRandomIntensity;
    stylingRandomDataRim.hardnessRandomMode = _RimHardnessRandomMode;
    stylingRandomDataRim.hardnessRandomIntensity = _RimHardnessRandomIntensity;
    stylingRandomDataRim.thicknessRandomMode = _RimThicknessRandomMode;
    stylingRandomDataRim.thicknesshRandomIntensity = _RimThicknesshRandomIntensity;


    DoToonShading(
#if _URP
            inputData,
            surface,
#else
            o,
            gi,
#if !_PASSFORWARDADD
            giInput,
#endif
#endif
            d,
#if _URP
#if UNITY_VERSION >= 202120
            normalTS,
#endif
#endif    
            albedo, _NumberOfCells, _CellTransitionSmoothness, _SumLightsBeforePosterization, _ShadingUseLightColors,
    
            uv, screenUV, _HatchingMap,
            
            _ShadingMode, _LightFunction,

            _EnableToonShading, _ShadingFunction,

            _GradientTex, _GradientTex_TexelSize, _GradientMode, _GradientBlending, _GradientBlendFactor,

            _EnableShadows, _CoreShadowColor,
    
            _TerminatorPosition,
    
            _TerminatorWidth, _TerminatorSmoothness, _FormShadowColor,
            _EnableCastShadows, _CastShadowsStrength, _CastShadowsSmoothness, _CastShadowColorMode, _CastShadowColor,
            _ShadingAffectedByNormalMap,
    
            _EnableSpecular, _SpecularBlending, _SpecularColor, _SpecularSize, _SpecularSmoothness, _SpecularOpacity, _SpecularAffectedByNormalMap, _SpecularUseLightColors,
            
            _EnableRim, _RimBlending, _RimColor, _RimSize, _RimSmoothness, _RimOpacity, _RimAffectedArea, _RimAffectedByNormalMap,
            
    
            _EnableStyling,
    
            uvSets,
    
            generalStylingData, _HatchingAffectedByNormalMap, _EnableAntiAliasing,
    
            _EnableShadingStyling,
            _StylingShadingSyncWithOtherStyling,
            _SyncWithLightPartitioning, _NumberOfCellsHatching,
            _StylingTerminatorPosition,
            _StylingOvermodelingFactor,
            positionAndBlendingDataShading, uvSpaceDataShading, stylingDataShading, stylingRandomDataShading,
    
            _EnableCastShadowsStyling,
            _StylingCastShadowsSyncWithOtherStyling,
            _CastShadowsNumberOfCellsHatching, _StylingCastShadowsSmoothness,
            positionAndBlendingDataCastShadows, uvSpaceDataCastShadows, stylingDataCastShadows, stylingRandomDataCastShadows,
    
            _EnableSpecularStyling,
            _SyncWithSpecular, _StylingSpecularSize, _StylingSpecularSmoothness, _StylingSpecularCutOutShading, _StylingSpecularUseLightColors,
            _StylingSpecularSyncWithOtherStyling,
            positionAndBlendingDataSpecular, uvSpaceDataSpecular, stylingDataSpecular, stylingRandomDataSpecular,
    
            _EnableRimStyling,
            _SyncWithRim, _StylingRimSize, _StylingRimSmoothness, _StylingRimAffectedArea,
            _StylingRimSyncWithOtherStyling,
            positionAndBlendingDataRim, uvSpaceDataRim, stylingDataRim, stylingRandomDataRim,


            _NoiseMap1, _NoiseMap2, _NoiseTex2_TexelSize,
            
            pureNormal);
    
}










#endif

