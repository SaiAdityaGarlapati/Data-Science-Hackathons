
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import requests
import re


# In[2]:


# test Data cleaning
# creating a ready to append address format which can be directly added into url request
before_address = "1/1070 RAMEGOUNDAN &^%$#@ PUDHUR,METTUPALAYAM,Coimbatore,TAMIL NADU,India"
#
#before_address = before_address.replace('[^A-Za-z0-9]+'," ")
before_address=re.sub('[^A-Za-z0-9]+', ' ', before_address)
address = before_address.replace(" ","+")

address = address.replace(".","")
address = address.replace(",",",+")
address


# In[4]:


# defining a params dict for the parameters to be sent to the API 
#google api key: AIzaSyBteTpIGwPMaCKOuiNbDQdHyYnLewdXVa4
#PARAMS = {'address':location} 
url = "https://maps.googleapis.com/maps/api/geocode/json?address="+address+"&key=AIzaSyBteTpIGwPMaCKOuiNbDQdHyYnLewdXVa4"
# sending get request and saving the response as response object 
r = requests.get(url = url) 
#, params = PARAMS
# extracting data in json format 
data = r.json() 

# extracting latitude, longitude and formatted address  
# of the first matching location 
latitude = data['results'][0]['geometry']['location']['lat'] 
longitude = data['results'][0]['geometry']['location']['lng'] 
formatted_address = data['results'][0]['formatted_address'] 
  
# printing the output 
print("Latitude:%s\nLongitude:%s\nFormatted Address:%s"
      %(latitude, longitude,formatted_address)) 


# In[8]:


latitude =[]
longitude =[]
formatted_address=[]
def fetch_location(address):
    # defining a params dict for the parameters to be sent to the API 
    address = address.lower()
    address=re.sub('[^A-Za-z0-9]+', ' ', address)
    address = address.replace(" ","+")
    address = address.replace(".","")
    address = address.replace(",",",+")
    #PARAMS = {'address':location} 
    url = "https://maps.googleapis.com/maps/api/geocode/json?address="+address+"&key=AIzaSyBteTpIGwPMaCKOuiNbDQdHyYnLewdXVa4"
    # sending get request and saving the response as response object 
    r = requests.get(url = url) 
    #, params = PARAMS
    # extracting data in json format 
    data = r.json() 
    # extracting latitude, longitude and formatted address  
    # of the first matching location 
    latitude.append(data['results'][0]['geometry']['location']['lat'])
    longitude.append(data['results'][0]['geometry']['location']['lng'])
    formatted_address.append(data['results'][0]['formatted_address'])
    # printing the output 
    #print("\nFormatted Address:%s"%(formatted_address))


# In[6]:


df = pd.read_csv("TN_Mapping.csv")
df['Total Address'] = df['Home Address']+','+df['City']+','+df['State']+',India'


# In[9]:


for i in df['Total Address']:
    fetch_location(i)


# In[10]:


df['latitude'] = latitude
df['longitude'] = longitude
df['formatted address']=formatted_address


# In[11]:


data = df[['Total Address','latitude','longitude','formatted address']]

data.to_csv("geocoding_googlemaps_api.csv")


# In[12]:


#data.loc(18,21,35)

