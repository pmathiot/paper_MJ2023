import numpy as np
import glob
import netCDF4 as nc
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from matplotlib import gridspec
import sys
import re
import argparse
import pandas as pd
import collections

def load_isf_name(cfile='STYLES/Isf_name.sty'):
    isf_name={}
    with open(cfile,'r') as namefile:
        for line in namefile:
            isfname          = line.split()[0]
            isf_name[isfname]= line.split()[1]
    return isf_name

def load_isfgroup(cgrp):
    with open('STYLES/grp.sty', 'r') as grpfile:
        for line in grpfile:
            grpname = line.split('|')[0].strip()
            if cgrp == grpname:
                isfl=line.split('|')[1].split()
                print('group '+cgrp+' is loaded')
                print(isfl)
        if not isfl:
            print('group '+cgrp+' not found; error')
            sys.exit(42)
    return isfl

def load_mltobs(cfile='MLT/Rignot_2013.txt',isflst=[]):
    print('load obs '+cfile)
    isf={}
    err={}
    with open(cfile, 'r') as obsfile:
        for line in obsfile:
            isfname    = line.split()[0]
            if isfname != 'TOTA':
                if isflst == [] or isfname in isflst:
                    isf[isfname]=float(line.split()[1])
                    err[isfname]=float(line.split()[2])
    return isf,err

def load_mltrun(cdir,crunid,cglob,isflst):
    print('load run '+crunid)
    cfile = sorted(glob.glob(cdir+'/'+crunid+'/'+cglob))
    if len(cfile) == 1 :
       ncid = nc.Dataset(cfile[0])
       isf={}
       try:
           for cisf in isflst:
               isf[cisf]=-np.squeeze(ncid.variables['isfmelt_'+cisf][0].data)
           isf['TOTAL']=-np.squeeze(ncid.variables['isfmelt_TOTA'][0].data)
       except:
           print('isf '+cisf+'not in input file : '+cfile)
           isf[cisf]=float('nan')
    else:
       print('Error more than 1 file : ',cfile,' in ',cdir+'/'+crunid+'/'+cglob)
       sys.exit(42)
    return isf

def load_att(runid,cfile):
    try:
        lstyle=False
        with open(cfile) as fid:
            for cline in fid:
                att=cline.split('|')
                if att[0].strip() == runid:
                    cpltname  = att[1].strip()
                    cpltclr   = att[3].strip()
                    cpltclrerr= att[4].strip()
                    lstyle=True
        return cpltclr, cpltname, cpltclrerr
    except:
        print( 'error in loading run.sty')
        raise Exception
    if not lstyle:
        print( runid+' not found in STYLES/run.sty' )
        raise Exception

def plot_figure(isf_obs, isf_run, isf_name, cgrp, ctitle, cout):

    plt.figure(figsize=np.array([200,300]) / 25.4)
    gs = gridspec.GridSpec(3, 2)
    ax = plt.subplot(gs[0:,0:])

    nplt=len(isf_run)+len(isf_obs)
    width = 0.8/nplt

    y = np.arange(len(isf_run[0]['melt'].keys())-1)

    for iobs, obs in enumerate(isf_obs):
        plot_bar(ax,obs,y,width,-(iobs+1)*width,lerr=True)

    for irun, run in enumerate(isf_run):
        plot_bar(ax,run,y, width, irun*width)
        print(run['melt'].keys())
        for iisf,cisf in enumerate(run['melt'].keys()):
            print(iisf,cisf,run['melt'][cisf]/run['melt']['TOTAL']*100)
#            if cisf != 'TOTAL':
#                ax.text(max(list(run['melt'].values())[0:-1])+5,y[iisf],'{:4.2f}%'.format(run['melt'][cisf]/run['melt']['TOTAL']*100),color=run['clr'],fontsize=14,verticalalignment='center')

    ax.tick_params('x',labelsize=14)
    ax.tick_params('y',labelsize=14)

    #ax.set_xlim([-10,max(list(run['melt'].values())[0:-1])+50])

    ax.set_ylim([-1,np.max(y)+1])
    ax.set_yticks(y)
    ax.set_yticklabels(list(isf_run[0]['melt'].keys())[0:-1])
    ax.set_yticklabels([isf_name[isfn] for isfn in list(isf_run[0]['melt'].keys())[0:-1]])

    #ax.set_xlabel('integrated ice shelf melt [Gt/y]',fontsize=16)

    ax.set_title(ctitle,fontsize=18)

    plt.grid(linestyle=':')

    #ax.legend(bbox_to_anchor=(1.05, 1), loc='lower left', frameon=False, fontsize=14)
    #ax.legend(bbox_to_anchor=( 0.00, -0.12), loc='lower left', frameon=False, fontsize=14, ncol=3)

    plt.subplots_adjust(left=0.28,right=0.98, bottom=0.12, top=0.95, wspace=0.1, hspace=0.1)

    ax.legend(bbox_to_anchor=( 0.00, -0.12), loc='lower left', frameon=False, fontsize=16, ncol=2)

    print('save figure ...')
    print(cout+'.png')
    plt.savefig(cout+'.png', format='png', dpi=300)

def plot_bar(ax,isfd,ry,rw,ro,lerr=False):
    if lerr :
        print(isfd['name'])
        zmlt=list(isfd['melt'].values())[0:-1]
        zerr=list(isfd['error'].values())
        ax.barh(ry+ro, zmlt, rw, label=isfd['name'],color=isfd['clr'],xerr=zerr,ecolor=isfd['clrerr'], hatch='//')
    else :
        print(isfd['name'])
        ax.barh(ry+ro,  list(isfd['melt'].values())[0:-1], rw, label=isfd['name'],color=isfd['clr'])


def load_arguments():
    # deals with argument
    parser = argparse.ArgumentParser()
    parser.add_argument("-runid", metavar='runid list'   , help="used to look information in runid.db"   , type=str, nargs="+" , required=True )
    parser.add_argument("-obsid", metavar='runid list'   , help="used to look information in runid.db"   , type=str, nargs="+" , required=False, default=[])
    parser.add_argument("-f", metavar='isf melt file', help="file list to plot (default is runid_var.nc)", type=str, nargs="+" , required=False)
    parser.add_argument("-g", metavar='isf group (WAIS, WEDD, EAIS)', help="group of ice shelf", type=str, nargs=1 , default='', required=False)
    parser.add_argument("-t", metavar='title extension', help="title extension (-g+' '+-t)", type=str, nargs=1 , default='', required=False)

    parser.add_argument("-dir"  , metavar='directory of input file' , help="directory of input file", type=str, nargs=1   , required=False, default=['./'])
    parser.add_argument("-o"    , metavar='figure_name', help="output figure name without extension", type=str, nargs=1   , required=False, default=['output'])
    return parser.parse_args()

def main():
    args = load_arguments()

    isf_lst=load_isfgroup(args.g[0])

    isf_name=load_isf_name()

    isf_run=[]
    for irun, runid in enumerate(args.runid):
        run={}
        run['melt']=load_mltrun(args.dir[0],runid,args.f[irun],isf_lst) 
        run['clr'], run['name'],_ =load_att(runid,'STYLES/run.sty')
        isf_run.append(run)

    isf_obs=[]
    for iobs, obsid in enumerate(args.obsid):
        obs={}
        obs['melt'],obs['error']=load_mltobs('MLT/'+obsid+'.txt',isf_lst)
        obs['clr'], obs['name'],obs['clrerr'] =load_att(obsid,'STYLES/obs.sty')

        # update dictionary order
        obs['melt']=collections.OrderedDict(obs['melt'])
        for k in list(isf_run[0]['melt'].keys()):
            if k not in obs['melt'].keys():
                obs['melt'][k]=np.nan
            obs['melt'].move_to_end(k)
        isf_obs.append(obs)

    print('plot figure ...')
    plot_figure(isf_obs,isf_run,isf_name,args.g[0],args.t[0]+' integrated ice shelf melt [Gt/y]',args.o[0])

    print('plot_show')
    plt.show()

if __name__=="__main__":
    main()
