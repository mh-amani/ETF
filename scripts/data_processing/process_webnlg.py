import xml.etree.ElementTree as ET
from datetime import date
import dateutil.parser as parser
import numpy as np
from utils import *

datetime_relations = ['P2031', 'P2032', 'P569', 'P570', 'P1619', 'P1636', 'P606']

def extract_relation_and_entities(triplet, code):
    ids = code.split(" | ")
    sforms = triplet.split(" | ")
    assert len(ids) == 3
    assert len(sforms) == 3
    assert ids[1].startswith("P")  # relations start with P
    relation = (ids[1], sforms[1])
    entities = []
    if ids[0].startswith("Q"):
        entities.append((ids[0], sforms[0]))
    if ids[2].startswith("Q"):
        entities.append((ids[2], sforms[2]))
    return relation, entities


def get_relations_entities_webnlg(
    path, entity_file, relation_file, existing_entities_path=None, existing_relations_path=None
):
    if existing_entities_path is None:
        existing_entities = set()
    else:
        with open(existing_entities_path, "rb") as f:
            existing_entities = pickle.load(f)

    if existing_relations_path is None:
        existing_relations = set()
    else:
        with open(existing_relations_path, "rb") as f:
            existing_relations = pickle.load(f)

    tree = ET.parse(path)
    benchmark = tree.getroot()
    entries = benchmark[0]
    for entry in entries:
        for triplet in entry.iter("modifiedtripletset"):
            mtriplet = triplet[0]
            mtriplet_text = mtriplet.text.strip()
            mcode = mtriplet[0].text.strip()
            relation, entities = extract_relation_and_entities(mtriplet_text, mcode)
            existing_relations.add(relation)
            existing_entities.update(entities)

    print("Number of entities: " + str(len(existing_entities)))
    print("Number of relations: " + str(len(existing_relations)))
    with open(entity_file, "wb") as f:
        pickle.dump(existing_entities, f)
    with open(relation_file, "wb") as f:
        pickle.dump(existing_relations, f)


def choose_lex(lexes):
    good_lexes = []
    for lex in lexes:
        if lex['quality'] == 'good':
            good_lexes.append(lex)

    if len(good_lexes) > 0:
        idx = np.random.randint(0, len(good_lexes))
        return good_lexes[idx]
    else:
        idx = np.random.randint(0, len(lexes))
        return lexes[idx]


def extract_unit_from_text(text, literal):
    idx = text.find(literal)
    if idx == -1:
        literal = literal.split('.')[0]
        idx = text.find(literal)
        if idx == -1:
            return literal, ""
    boundary = idx + len(literal)
    words = text[boundary:].split()
    unit = words[0]
    unit = ''.join(filter(str.isalpha, unit))
    if unit == "square" or unit == 'sq':
        unit = "square " + process_word(words[1])
    else:
        unit = process_word(unit)
    return literal, unit


def extract_unit_from_literal(s):
    s = s.strip("(").strip(")")
    if s.startswith("sq"):
        unit = "square " + process_word(s.split()[1])
        return unit
    return process_word(s)


def format_datetime_literal(literal):
    literal = literal.strip('"')
    ids = literal.split("-")
    if len(ids) == 3:
        year = ids[0]
        month = ids[1]
        day = ids[2]
        date_obj = date(int(year), int(month), int(day))
        value = date_obj.strftime("%d %B %Y")
    else:
        ids = literal.split()
        if len(ids) == 1:
            value = str(ids[0])
        else:
            try:
                date_obj = parser.parse(literal)
                value = date_obj.strftime("%B %Y")
            except:
                value = ""
    return value


def extract_literal(text, literal, relation):
    if relation in datetime_relations:
        lit = format_datetime_literal(literal)
        return lit, "date"
    if is_a_num(literal):
        literal, unit = extract_unit_from_text(text, literal)
        if relation == "P2044":
            unit = 'metre'
        lit = literal + " " + unit
        return lit, "quantity"
    elif is_a_num(literal.split()[0]):
        unit = extract_unit_from_literal(" ".join(literal.split()[1:]))
        lit = literal.split()[0] + " " + unit
        return lit, "quantity"
    else:
        return "", None
        # string
        # literal = literal.strip('"')
        # return literal


def extract_triplets(self, text, code, entities, relations):
    sforms = text.split(" | ")
    ids = code.split(" | ")
    assert (len(ids) == 3)
    assert (len(sforms) == 3)
    assert (ids[1].startswith('P'))
    triplet = {'subject': {}, 'relation': {}, 'object': {}}
    triplet['subject']['id'] = ids[0]
    triplet['relation']['id'] = ids[1]
    triplet['object']['id'] = ids[2]

    if ids[0] in self.en_map:
        triplet['subject']['name'] = self.en_map[ids[0]]
    else:
        triplet['subject']['name'] = sforms[0]

    if ids[2] in self.en_map:
        triplet['object']['name'] = self.en_map[ids[2]]
    else:
        triplet['object']['name'] = sforms[2]

    triplet['relation']['name'] = self.rel_map[ids[1]]

    entities.append(ids[0])
    entities.append(ids[2])
    relations.append(ids[1])
    return triplet, entities, relations
