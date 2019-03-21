#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np


# In[2]:


data = pd.read_csv("geocoding_googlemaps_api.csv")


# In[3]:


import matplotlib.pyplot as plt
import os
os.environ["PROJ_LIB"] = "C:/Users/Aditya/Anaconda3/Library/share" #fixr
from mpl_toolkits.basemap import Basemap
import pandas as pd
import io


# In[4]:


# read in data to use for plotted points

lat = data['latitude'].values
lon = data['longitude'].values


# In[5]:


# determine range to print based on min, max lat and lon of the data
plt.figure(figsize=(20,10))
margin = 2 # buffer to add to the range
lat_min = min(lat) - margin
lat_max = max(lat) + margin
lon_min = min(lon) - margin
lon_max = max(lon) + margin

# create map using BASEMAP
m = Basemap(llcrnrlon=lon_min,
            llcrnrlat=lat_min,
            urcrnrlon=lon_max,
            urcrnrlat=lat_max,
            lat_0=(lat_max - lat_min)/2,
            lon_0=(lon_max-lon_min)/2,
            projection='merc',
            resolution = 'h',
            area_thresh=10000.,
            )
m.drawcoastlines()
m.drawcountries()
m.drawstates()
m.drawmapboundary(fill_color='#46bcec')
m.fillcontinents(color = 'white',lake_color='#46bcec')
# convert lat and lon to map projection coordinates
lons, lats = m(lon, lat)
# plot points as red dots
m.scatter(lons, lats, marker = 'o', color='r', zorder=5)
plt.show()

