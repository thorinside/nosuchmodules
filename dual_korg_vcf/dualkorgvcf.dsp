// dualkorgvcf.dsp
import("stdfaust.lib");

maxQ = 24.9;
maxQKorg = 9.9;
ratio = maxQKorg/maxQ;

QL = (maxQ, (0.7072, (hslider("q1",1,0.7072,maxQ,0.01) + hslider("q1cv",1,0.7072,maxQ,0.01)) : max) : min) : si.smoo;
normFreqL = (1.0, (0.0, (hslider("freq1",0.1,0,0.9,0.005) + hslider("freq1cv",0.1,0,0.9,0.005)) : max) : min) : si.smoo;
QR = (maxQ, (0.7072, (hslider("q2",1,0.7072,maxQ,0.01) + hslider("q2cv",1,0.7072,maxQ,0.01)) : max) : min) : si.smoo;
normFreqR = (1.0, (0.0, (hslider("freq2",0.1,0,0.9,0.005) + hslider("freq2cv",0.1,0,0.9,0.005)) : max) : min) : si.smoo;

switch = checkbox("SWITCH") : int : si.smoo;

// Process both filters for each channel
l_korg = ve.korg35LPF(normFreqL, QL*ratio);
l_moog = ve.moogLadder(normFreqL, QL);
r_korg = ve.korg35LPF(normFreqR, QR*ratio);
r_moog = ve.moogLadder(normFreqR, QR);

// Blend based on the switch value
l = (l_korg * (1 - switch)) + (l_moog * switch);
r = (r_korg * (1 - switch)) + (r_moog * switch);

process = _,_ : ((_ <: l), (_ <: r));