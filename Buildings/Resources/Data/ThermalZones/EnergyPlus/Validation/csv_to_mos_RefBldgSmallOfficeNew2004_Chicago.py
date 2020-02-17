import csv
import os

def convert_row(time, row):
    def to_K(degC):
        return float(degC) + 273.15
    data = {'time': time, \
        'TOut': to_K(row[1]), \
        'TCor': to_K(row[5]), \
        'TSou': to_K(row[6]), \
        'TEas': to_K(row[7]), \
        'TNor': to_K(row[8]), \
        'TWes': to_K(row[9]), \
        'TAtt': to_K(row[4])}
    return "{time:6d} {TOut:0.2f} {TCor:0.3f} {TSou:0.3f} {TEas:0.3f} {TNor:0.3f} {TWes:0.3f} {TAtt:0.3f}".format(**data)


ent = []

with open(os.path.join('EnergyPlus', 'eplusout.csv'), 'r') as csvfile:
    rows = csv.reader(csvfile, delimiter=',')
    iRow = 1
    for row in rows:
        if iRow > 1:
            if iRow == 2:
                # Enter first row twice, as E+ does not record t=0
                ent.append(convert_row(0, row))
            ent.append(convert_row((iRow-1)*900, row))
        iRow = iRow + 1
with open('RefBldgSmallOffice.dat', 'w') as out:
    out.write("#1\n")
    out.write("# Generated by csv_to_mos_RefBldgSmallOfficeNew2004_Chicago.py\n")
    out.write("double EnergyPlus({}, 8)\n".format(str(len(ent))))
    for e in ent:
        out.write("{}\n".format(e))