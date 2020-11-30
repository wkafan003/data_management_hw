use movie;


print('tags count: ', db.tags.count();

print('Adventure" tags count: ', db.tags.countDocuments({tag_name:'Adventure'}));

printjson(db.tags.aggregate([{$group:{_id:"$tag_name",cnt:{$sum:1}}},{ $sort: { cnt: -1 }} ,{$limit:3}]));