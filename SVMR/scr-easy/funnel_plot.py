import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pylab import *
from matplotlib.ticker import MultipleLocator, FormatStrFormatter

font1 = {'family': 'Arial'}
# path = '/Users/zhangmeng/Desktop/car_ss.csv'
# path = '/Users/zhangmeng/Desktop/diet/tables/SS/new/Car_SS.csv'
# path_1 = '/Users/zhangmeng/Desktop/diet/tables/SS/new/sugar_SS.csv'
# path_1 = '/Users/zhangmeng/Desktop/sugar_ss.csv'
path_1 = '/Users/zhangmeng/Desktop/MDD_CarSu/car_ss.csv'
# data = pd.read_csv(path) #读取文件中所有数据
data = pd.read_csv(path_1) #读取文件中所有数据
print(data)

l1 = plt.axvline(x=0.0377, ls="-", lw=1, c="orange")#添加垂直直线
l2 = plt.axvline(x=-0.9994, ls="-", lw=1, c="pink")#添加垂直直线
plt.legend(handles=[l1, l2], labels=('IVW', 'MR Egger'), loc='upper right', prop=font1)

a = []
b = []
for i in range(0, len(data)-1):
    a.append(data.iloc[i, 1])

for i in range(0, len(data)-1):
    b.append(1/(data.iloc[i, 2]))
plt.scatter(a, b, s=15, c='#235a82', zorder=2)
print(a)
print(b)

# plt.xlabel('SNP effect on sugar (β)', font1)
plt.xlabel('SNP effect on carbohydrate (β)', font1)
plt.ylabel('SNP precision (1/SE)', font1)

ax = plt.gca()
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.set_ylim(7, 9)
ax.yaxis.set_major_locator(MultipleLocator(0.5))
plt.savefig('/Users/zhangmeng/Desktop/carbohydrate_funnel.pdf')
# plt.savefig('/Users/zhangmeng/Desktop/sugar_funnel.pdf')

plt.show()
