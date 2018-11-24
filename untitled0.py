#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 18 14:34:16 2018

@author: mariellejurist
"""


import pandas as pd
import numpy as np

from py_translator import Translator

df = pd.read_csv('job_skill_short.csv')

translator = Translator()
x = (df.loc[[100],['Title', 'Responsibilities','Minimum.Qualifications','Preferred.Qualifications']].values).tolist()

translations = translator.translate(x).text


