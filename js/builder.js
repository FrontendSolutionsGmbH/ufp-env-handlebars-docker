const path = require('path')
const {
  execSync
} = require('child_process')
console.log('BUILDING AND STARTING')

process.env.CFG_MENU_0_LABEL = 'people'
process.env.CFG_MENU_0_CHILDREN_0_LABEL = 'people1'
process.env.CFG_MENU_0_CHILDREN_0_CHILDREN_0_LABEL = 'people2'
process.env.CFG_MENU_1_LABEL = 'local'
process.env.CFG_MENU_2_LABEL = 'local2'

const path2 = path.join(process.cwd(), 'execute.sh')
const result2 = execSync(path2, {
  shell: true,
  cwd: path.join(process.cwd(), 'dist')
})

console.log(path2)
console.log(result2.toString())
