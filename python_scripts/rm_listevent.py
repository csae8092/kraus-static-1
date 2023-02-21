import glob
from tqdm import tqdm
from acdh_tei_pyutils.tei import TeiReader
counter = 0
files = sorted(glob.glob('./data/editions/*.xml'))

for x in tqdm(files, total=len(files)):
    try:
        doc = TeiReader(x)
    except:
        continue
    for bad in doc.any_xpath('.//tei:back//tei:listEvent'):
        # log?
        counter += 1
        bad.getparent().remove(bad)
    doc.tree_to_file(x)
if counter > 0:
    counter = str(counter)
    input(f"\n*2{counter} bach elmente gelöscht, sollte man besser loggen?\n*2")